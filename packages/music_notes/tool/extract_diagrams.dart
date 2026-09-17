// Renders `doc/grammar/grammar.ebnf` via `npx ebnf2railroad`, then
// extracts one self-contained SVG per named rule into
// `doc/diagrams/<ClassName>.svg`, inlining only the CSS that rule's
// diagram actually references.
//
// Usage: `dart tool/extract_diagrams.dart [--out doc/diagrams]`
//
// NOTE: this still requires Node/npm on PATH to run `ebnf2railroad`, which
// has no Dart equivalent. Everything *committed to this repo* is pure
// Dart; the external tool call itself is an acknowledged, deliberate
// exception (see the "pure Dart" discussion this script came out of).
//
// IMPORTANT: relies on ebnf2railroad's *current* HTML structure (an
// `<h4 id="{ruleName}">` immediately followed by a `<div class=
// "diagram-container"><svg>`, plus CSS in `<style>` blocks and/or a local
// `<link rel="stylesheet">`). That structure is an implementation detail,
// not a published contract. Re-verify it against actual output whenever
// the pinned `ebnf2railroad` version changes.

import 'dart:io';

import 'package:args/args.dart';
import 'package:csslib/parser.dart' as css_parser;
import 'package:csslib/visitor.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:path/path.dart' as p;

const ruleToClass = <String, String>{
  'english_note_name': 'EnglishNoteNameNotation',
  'german_note_name': 'GermanNoteNameNotation',
  'romance_note_name': 'RomanceNoteNameNotation',
  'english_note': 'EnglishNoteNotation',
  'german_note': 'GermanNoteNotation',
  'romance_note': 'RomanceNoteNotation',
  'scientific_pitch': 'ScientificPitchNotation',
  'helmholtz_pitch': 'HelmholtzPitchNotation',
  'numbered_helmholtz_pitch': 'HelmholtzPitchNotation.numbered',
  'abc_pitch': 'AbcPitchNotation',
  'standard_interval': 'StandardIntervalNotation',
  'german_interval': 'GermanIntervalNotation',
  'roman_scale_degree': 'RomanScaleDegreeNotation',
  'numeric_scale_degree': 'NumericScaleDegreeNotation',
  'solfege_scale_degree': 'SolfegeScaleDegreeNotation',
  'english_key': 'EnglishKeyNotation',
  'german_key': 'GermanKeyNotation',
  'romance_key': 'RomanceKeyNotation',
  'chord_pattern': 'ChordPatternNotation',
  'chord': 'ChordNotation',
  'frequency': 'FrequencySINotation',
  'compact_tuning_fork': 'CompactTuningForkNotation',
  'scientific_tuning_fork': 'ScientificTuningForkNotation',
  'closest_pitch': 'StandardClosestPitchNotation',
  'enharmonic_pitch_class': 'EnharmonicSpellingsPitchClassNotation',
  'integer_pitch_class': 'IntegerPitchClassNotation',
};

const grammarPath = 'doc/grammar/grammar.ebnf';

Future<void> main(List<String> arguments) async {
  final args = (ArgParser()..addOption('out', defaultsTo: 'doc/diagrams'))
      .parse(arguments);
  final outDir = args['out']! as String;

  await Directory(outDir).create(recursive: true);

  final rendered = await _renderGrammar(grammarPath);
  final pageCss = await _collectPageCss(rendered.document, rendered.htmlDir);

  for (final MapEntry(key: ruleName, value: className) in ruleToClass.entries) {
    final rawSvg = _extractSvgElement(rendered.document, ruleName);
    final svg = _stripDanglingLinks(rawSvg, ruleName);
    final relevantCss = _relevantCss(pageCss, _usedClasses(svg));

    if (relevantCss.trim().isEmpty) {
      throw StateError(
        'Filtered CSS for "$ruleName" ($className) is empty even though '
        'page CSS was found. _usedClasses() or _relevantCss() likely isn’t '
        "matching this diagram's actual class names. Inspect the rendered "
        '<svg> and stylesheet before trusting this output.',
      );
    }

    final outPath = p.join(outDir, '$className.svg');
    await File(outPath).writeAsString(_makeStandalone(svg, relevantCss));
    stdout.writeln('wrote $outPath');
  }
}

final class _RenderedGrammar {
  const _RenderedGrammar(this.document, this.htmlDir);

  final Document document;
  final String htmlDir;
}

/// Renders [grammarPath] once via `npx ebnf2railroad` and parses the result.
Future<_RenderedGrammar> _renderGrammar(String grammarPath) async {
  final tmpDir = await Directory.systemTemp.createTemp('ebnf2railroad_');
  final outHtml = p.join(tmpDir.path, 'grammar.html');

  final result = await Process.run('bunx', [
    'ebnf2railroad',
    grammarPath,
    '-o',
    outHtml,
  ]);
  if (result.exitCode != 0) {
    throw ProcessException(
      'npx',
      ['ebnf2railroad', grammarPath, '-o', outHtml],
      'ebnf2railroad failed:\n${result.stderr}',
      result.exitCode,
    );
  }

  final source = await File(outHtml).readAsString();

  return _RenderedGrammar(html_parser.parse(source), tmpDir.path);
}

/// Collects CSS from every `<style>` block and any local
/// `<link rel="stylesheet">` next to the rendered HTML. Absolute URLs are
/// skipped rather than fetched, since diagram styling shouldn't depend on
/// network access. Throws if no CSS is found at all, rather than silently
/// producing unstyled diagrams.
Future<String> _collectPageCss(Document document, String htmlDir) async {
  final blocks = [
    for (final style in document.querySelectorAll('style')) style.text,
  ];

  for (final link in document.querySelectorAll('link[rel="stylesheet"]')) {
    final href = link.attributes['href'];
    if (href == null ||
        href.startsWith('http://') ||
        href.startsWith('https://') ||
        href.startsWith('data:')) {
      continue; // remote or inline data URI: not a local file to read
    }

    final file = File(p.join(htmlDir, href));
    if (file.existsSync()) {
      blocks.add(await file.readAsString());
    } else {
      stderr.writeln('could not read linked stylesheet "$href"; skipping');
    }
  }

  final pageCss = blocks.join('\n');
  if (pageCss.trim().isEmpty) {
    throw StateError(
      'No CSS found in rendered output (neither <style> blocks nor a '
      'readable <link rel="stylesheet">): diagrams would render '
      'unstyled. Inspect the rendered HTML and update _collectPageCss().',
    );
  }

  return pageCss;
}

/// Finds `<h4 id="ruleId">` and returns the outer HTML of the first `<svg>`
/// that follows it in document order, e.g., that rule's diagram. Walking
/// forward through following siblings (rather than assuming a fixed
/// wrapper depth) tolerates `ebnf2railroad` changing its exact container
/// markup around the heading and diagram.
String _extractSvgElement(Document document, String ruleId) {
  final heading = document.getElementById(ruleId);
  if (heading == null) {
    throw StateError('No element with id="$ruleId" found in rendered output');
  }

  Element? node = heading;
  while (node != null) {
    final svg = node.localName == 'svg' ? node : node.querySelector('svg');
    if (svg != null) return svg.outerHtml;
    node = node.nextElementSibling;
  }

  throw StateError('No <svg> found following heading "$ruleId"');
}

/// Removes `xlink:href` from any `<a>` whose target isn't [ruleId] itself
/// (e.g., every cross-reference to a sibling rule, which won't resolve once
/// this diagram is isolated into its own file), while keeping the `<a>`'s
/// visible content and styling intact.
String _stripDanglingLinks(String svg, String ruleId) => svg.replaceAllMapped(
  RegExp(r'<a\s+xlink:href="#([^"]+)"([^>]*)>'),
  (match) => match[1] == ruleId ? match[0]! : '<a${match[2]}>',
);

/// Every distinct class token used anywhere within [svg].
Set<String> _usedClasses(String svg) => {
  for (final match in RegExp('class="([^"]+)"').allMatches(svg))
    ...match[1]!.split(RegExp(r'\s+')).where((name) => name.isNotEmpty),
};

/// [pageCss] filtered to only the rules whose selector mentions at least
/// one class in [usedClasses]. Selectors with no class component (bare
/// tag/`svg`/`text` rules, generic layout) are kept unconditionally, since
/// they're structural rather than diagram-specific.
///
/// NOTE: only top-level rule sets are filtered; rules nested inside an
/// `@media` block are left untouched (kept, not dropped); worst case this
/// ships slightly more CSS than strictly needed, never less. Verify the
/// exact `csslib` visitor API surface below against the installed version
/// (`RuleSet`/`SimpleSelectorSequence`/`ClassSelector` field names, and
/// `CssPrinter.visitTree`'s exact parameters) since none of it is pinned
/// to a specific `csslib` version here.
String _relevantCss(String pageCss, Set<String> usedClasses) {
  final stylesheet = css_parser.parse(pageCss);

  stylesheet.topLevels.removeWhere((node) {
    if (node is! RuleSet) return false;

    final classesInSelector = [
      for (final selector
          in node.selectorGroup?.selectors ?? const <Selector>[])
        for (final sequence in selector.simpleSelectorSequences)
          if (sequence.simpleSelector case final ClassSelector selector)
            selector.name,
    ];

    if (classesInSelector.isEmpty) return false; // keep structural rules

    return !classesInSelector.any(usedClasses.contains);
  });

  return (CssPrinter()..visitTree(stylesheet)).toString();
}

/// Ensures [svg] is valid as a standalone file: declares `xmlns` (implicit,
/// and often omitted, when embedded directly inside an HTML page), declares
/// `xmlns:xlink` if any `xlink:`-prefixed attribute remains (an undeclared
/// namespace prefix is an XML parse error, not just a broken link), and
/// inlines [css].
String _makeStandalone(String svg, String css) {
  var result = svg;
  if (!result.contains('xmlns=')) {
    result = result.replaceFirst(
      '<svg',
      '<svg xmlns="http://www.w3.org/2000/svg"',
    );
  }
  if (result.contains('xlink:') && !result.contains('xmlns:xlink=')) {
    result = result.replaceFirst(
      '<svg',
      '<svg xmlns:xlink="http://www.w3.org/1999/xlink"',
    );
  }

  final openTagEnd = result.indexOf('>') + 1;

  return '${result.substring(0, openTagEnd)}<style>$css</style>'
      '${result.substring(openTagEnd)}';
}
