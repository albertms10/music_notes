// Renders `doc/grammar/grammar.ebnf` via `bunx ebnf2railroad`, then
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
    final classes = _usedClasses(svg);
    final css = _buildThemeCss(pageCss, classes);

    final path = p.join(outDir, '$className.svg');
    await File(path).writeAsString(_makeStandalone(svg, css));
    await minifySvg(path);
    stdout.writeln('wrote $path');
  }
}

final class _RenderedGrammar {
  const _RenderedGrammar(this.document, this.htmlDir);

  final Document document;
  final String htmlDir;
}

/// Runs `bunx ebnf2railroad [args]` and derives success/failure from its
/// own printed output rather than `result.exitCode` — `bunx` (like `npx`)
/// has a documented history of not reliably forwarding the wrapped
/// process's real exit code, particularly on an install-then-run first
/// invocation, which is exactly the gap that let a real lint failure
/// (exit 2) surface here as an apparent success (exit 0).
///
/// NOTE: `lintFailurePattern` below is a best-effort guess at
/// ebnf2railroad's lint-summary format ("N error(s)"/"N problem(s)"), not
/// verified against real `--lint` failure output. Run it once against a
/// grammar file you know has a lint issue and adjust the pattern if it
/// doesn't match — this intentionally fails loud (treats unrecognized
/// output as a pass only when *no* failure-shaped text is found at all)
/// rather than silently trusting exitCode again.
Future<ProcessResult> _runEbnf2Railroad(List<String> args) async {
  final result = await Process.run('bunx', ['ebnf2railroad', ...args]);
  final output = '${result.stdout}\n${result.stderr}';

  final lintFailurePattern = RegExp(
    r'(\d+)\s+(error|problem|issue)s?|line \d+\b',
    caseSensitive: false,
  );
  final match = lintFailurePattern.firstMatch(output);
  final reportedFailures = match != null && int.parse(match.group(1)!) > 0;

  if (reportedFailures && result.exitCode == 0) {
    stderr.writeln(
      'bunx reported exit code 0 but output looks like a lint failure — '
      'trusting the output over the exit code.',
    );
    return ProcessResult(result.pid, 2, result.stdout, result.stderr);
  }

  return result;
}

/// Renders [grammarPath] once via `bunx ebnf2railroad` and parses the result.
Future<_RenderedGrammar> _renderGrammar(String grammarPath) async {
  final tmpDir = await Directory.systemTemp.createTemp('ebnf2railroad_');
  final outHtml = p.join(tmpDir.path, 'grammar.html');
  final result = await _runEbnf2Railroad([
    grammarPath,
    '--lint',
    '--write-style',
    '-o',
    outHtml,
  ]);
  if (result.exitCode != 0) {
    throw ProcessException(
      'bun',
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

/// Resolves the page CSS into a single stylesheet containing the light theme
/// as the default `:root` and the dark theme as a `prefers-color-scheme: dark`
/// override.
///
/// The resulting CSS is suitable for embedding in an SVG <style> element:
///
///   :root{--foo:light;...}
///   @media (prefers-color-scheme:dark){:root{--foo:dark;...}}
///
/// This avoids emitting two independent theme stylesheets or relying on
/// duplicate `:root` rules being preserved by SVG/CSS minifiers.
///
/// NOTE: only top-level rule sets are inspected for the used-class filter;
/// rules nested inside an `@media` block are left untouched (kept, not
/// dropped) — worst case this ships slightly more CSS than strictly needed.
/// Verify the exact `csslib` visitor API surface against the installed
/// version (`RuleSet`/`SimpleSelectorSequence`/`ClassSelector` field names,
/// and `CssPrinter.visitTree`'s exact parameters).
String _buildThemeCss(
  String pageCss,
  Set<String> usedClasses,
) {
  final rootBody = _extractRuleBody(pageCss, ':root');
  if (rootBody == null) {
    throw StateError(
      'No ":root" rule found in page CSS — cannot resolve theme variables.',
    );
  }

  final themeDarkBody = _extractRuleBody(pageCss, '.theme-dark');

  if (themeDarkBody == null) {
    stderr.writeln(
      'warning: no ".theme-dark" rule found in page CSS — '
      'the SVG will contain only the light theme. Re-check the selector '
      'name against current ebnf2railroad output.',
    );
  }

  final lightVariables = _parseCustomProperties(rootBody);
  final darkVariables = themeDarkBody == null
      ? const <String, String>{}
      : _parseCustomProperties(themeDarkBody);

  final stylesheet = css_parser.parse(pageCss);

  stylesheet.topLevels.removeWhere((node) {
    if (node is! RuleSet) return false;

    // :root and .theme-dark are handled explicitly below.
    final sourceText = node.span.text.trimLeft();
    if (sourceText.startsWith(':root') ||
        sourceText.startsWith('.theme-dark')) {
      return true;
    }

    final classesInSelector = [
      for (final selector
          in node.selectorGroup?.selectors ?? const <Selector>[])
        for (final sequence in selector.simpleSelectorSequences)
          if (sequence.simpleSelector case final ClassSelector selector)
            selector.name,
    ];

    if (classesInSelector.isEmpty) {
      return false; // Keep structural rules.
    }

    return !classesInSelector.any(usedClasses.contains);
  });

  final remainingCss = (CssPrinter()..visitTree(stylesheet)).toString();

  String rootBlock(Map<String, String> variables) {
    final declarations = variables.entries
        .map((entry) => '${entry.key}:${entry.value};')
        .join();

    return ':root{$declarations}';
  }

  String darkMediaBlock(Map<String, String> variables) {
    if (variables.isEmpty) return '';

    return '@media (prefers-color-scheme:dark){${rootBlock(variables)}}';
  }

  return [
    rootBlock(lightVariables),
    darkMediaBlock(darkVariables),
    remainingCss,
  ].join();
}

/// Finds the first `<selector> { ... }` block in [css] and returns its
/// declaration body (the text between the braces), or `null` if [selector]
/// isn't found. Brace matching is naive character counting rather than a
/// real parser — safe here specifically because `:root`/`.theme-dark` in
/// this stylesheet contain only flat `--property: value;` declarations
/// with no nested braces (no `@media`, no nested rules).
String? _extractRuleBody(String css, String selector) {
  final selectorMatch = RegExp(
    '${RegExp.escape(selector)}\\s*\\{',
  ).firstMatch(css);
  if (selectorMatch == null) return null;

  final braceStart = selectorMatch.end - 1;
  var depth = 0;
  for (var i = braceStart; i < css.length; i++) {
    if (css[i] == '{') depth++;
    if (css[i] == '}') {
      depth--;
      if (depth == 0) return css.substring(braceStart + 1, i);
    }
  }

  return null; // unterminated block; malformed CSS
}

/// Parses `--custom-property: value;` declarations out of [ruleBody] (the
/// text between a rule's braces) into a property→value map. Only bare
/// custom-property declarations are handled — this stylesheet's
/// `:root`/`.theme-dark` blocks contain nothing else, so a full CSS-value
/// parser isn't needed here.
Map<String, String> _parseCustomProperties(String ruleBody) => {
  for (final match in RegExp(r'(--[\w-]+)\s*:\s*([^;]+);').allMatches(ruleBody))
    match.group(1)!: match.group(2)!.trim(),
};

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

/// Minifies the SVG at [path] in place via `svgo_cli`
/// (https://pub.dev/packages/svgo_cli).
///
/// UNVERIFIED: I'm inferring the activated command name (`svgo`) and its
/// flags (`-i`/`-o` for input/output) from SVGO's own conventional CLI
/// surface and this package's name, not from a confirmed read of
/// svgo_cli's own README/API. Check both before trusting this in CI:
///   - the exact command it installs on PATH after
///     `dart pub global activate svgo_cli` (may be `svgo_cli` rather
///     than `svgo`),
///   - whether its default preset strips anything this pipeline depends
///     on (`viewBox`, the `xmlns`/`xmlns:xlink` declarations added by
///     [_makeStandalone] — SVGO's default preset typically preserves the
///     root `xmlns`, but I have not confirmed its behavior on
///     `xmlns:xlink` specifically when no `xlink:` usage remains after
///     [_stripDanglingLinks]).
Future<void> minifySvg(String path) async {
  final result = await Process.run('svgo', [path]);
  if (result.exitCode != 0) {
    throw ProcessException(
      'svgo',
      [path],
      'svgo failed (exit ${result.exitCode}):\n${result.stderr}',
      result.exitCode,
    );
  }
}
