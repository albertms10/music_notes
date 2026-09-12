// ignore_for_file: avoid_print CLI

// A CLI tool for visualising a music_notes organ Stop composition
// (a `List<PipeRow>`, from the work-in-progress `organ` branch) in the
// terminal:
//
//   1. A log-frequency histogram of every pipe sounded across a keyboard
//      (see `_LogHistogram`), rendered with `package:artisanal`.
//   2. A pitch (x) vs. frequency-in-Hz-on-a-log-scale (y) chart, one line
//      per rank, coloured either by `PipeRow` breakpoint or by rank
//      position (`--color-by`). Wherever two or more ranks land on the
//      exact same pitch — e.g. a mixture repeating a foot length within a
//      row to keep the ambitus full near a break — the marker is drawn
//      bigger (and bold, at three or more) instead of silently
//      overlapping. Rendered with a small purpose-built ANSI renderer (see
//      `_renderRankLinesChart`).
//
// Every key of a keyboard is walked chromatically; for each key, the
// [PipeRow] that applies at that key (`StopComposition.rowFor`) supplies a
// set of rank [Interval]s (one per foot-length), which are used to
// transpose *that key* into each rank's actual sounding [Pitch]. That's
// what makes a mixture's break structure visible: instead of one smooth
// curve, you see the sawtooth of ranks jumping back down an octave (or
// more) each time a breakpoint is crossed.
//
// Why chart 2 isn't built on `artisanal` too: `package:artisanal`'s public
// API turned out to be a moving target while building this (the pub.dev
// docs for `charting.dart`'s `BarChartProps`/`DataSeries`/`AxisOptions`,
// used for chart 1, are stable enough to rely on; but its multi-series
// `LineChartProps` shape wasn't pinnable from the docs available while
// writing this, and a *different* `LineChart` — a stateful TUI widget in
// `package:artisanal/widgets.dart`, unrelated to the plain
// print-and-done `charting.dart` functions — kept surfacing instead).
// Rather than guess at an unverified signature, chart 2 is self-contained.
// Worth re-checking against your installed version before relying on
// either chart, since none of this could actually be compiled here.
//
// Usage:
//   dart run bin/organ_frequency_chart.dart
//   dart run bin/organ_frequency_chart.dart --file my_mixture.txt
//   dart run bin/organ_frequency_chart.dart --charts breaks --line-height 30
//   dart run bin/organ_frequency_chart.dart --help
//
// With no --file given, an example Fourniture IV-style mixture is used.

import 'dart:io';
import 'dart:math' as math;

import 'package:args/args.dart';
import 'package:artisanal/charting.dart';
import 'package:music_notes/music_notes.dart';
import 'package:music_notes/organ.dart';
import 'package:music_notes/utils.dart';

const _fournitureExample = '''
C			1 1/3'	1'	2/3'	1/2'
c			2'	1 1/3'	1'	2/3'
g		2'	1 1/3'	1' 	1'	2/3'
c'	2 2/3'	2'	1 1/3'	1' 	1'	2/3'
c''	4'	2 2/3'	2'	2'	1 1/3' 	1'
gis''	5 1/3'	4'	2 2/3'	2'	2'	4/3'
cis\'''	5 1/3'	4'	2 2/3'	2 2/3'	2'	2'
''';

/// ANSI 3/4-bit colour codes, cycled per [PipeRow] (red, green, yellow,
/// blue, magenta, cyan, and their bright variants).
const _palette = [31, 32, 33, 34, 35, 36, 91, 92, 93, 94, 95, 96];

/// "Nice" frequency values considered for y-axis gridlines.
const _niceHertz = [
  20, 30, 50, 70, 100, 150, 200, 300, 500, 700, //
  1000, 1500, 2000, 3000, 5000, 7000, 10000, 15000, 20000,
];

Future<void> main(List<String> arguments) async {
  final parser = _buildParser();

  final ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (error) {
    stderr
      ..writeln(error.message)
      ..writeln(parser.usage);
    exitCode = 64;
    return;
  }

  if (results.flag('help')) {
    stdout
      ..writeln('Usage: dart run bin/organ_frequency_chart.dart [options]\n')
      ..writeln(parser.usage);
    return;
  }

  final Pitch from;
  final Pitch to;
  try {
    from = Pitch.parse(results.option('from')!);
    to = Pitch.parse(results.option('to')!);
  } on FormatException catch (error) {
    stderr.writeln('Invalid --from/--to pitch: $error');
    exitCode = 64;
    return;
  }

  final file = results.option('file');
  final List<PipeRow> composition;
  try {
    composition = StopComposition.parse(
      file == null ? _fournitureExample : File(file).readAsStringSync(),
    );
  } on FormatException catch (error) {
    stderr.writeln('Could not parse the stop composition: $error');
    exitCode = 65;
    return;
  }
  if (composition.isEmpty) {
    stderr.writeln('The stop composition is empty.');
    exitCode = 65;
    return;
  }

  // Every chromatic key across the keyboard extension, from and including
  // both ends, in ascending order.
  final keys = <Pitch>[...(from: from, to: to).explode(), to];

  final lines = _buildRankLines(composition, keys);
  final frequencies = [
    for (final line in lines)
      for (final (_, hertz) in line.points) hertz,
  ];

  if (frequencies.isEmpty) {
    stderr.writeln(
      'No pipes fall within ${from.format()}–${to.format()}: check the '
      'breakpoints in the composition.',
    );
    exitCode = 65;
    return;
  }

  final title = results.option('title') ?? 'Stop composition';
  final width = int.parse(results.option('width')!);
  final charts = results.multiOption('charts');

  if (charts.contains('distribution')) {
    final histogram = _LogHistogram(
      frequencies,
      binsPerOctave: int.parse(results.option('bins-per-octave')!),
    );
    print(
      createBarChart(
        BarChartProps(
          width: width,
          height: int.parse(results.option('height')!),
          title: '$title — frequency distribution (log scale)',
          series: [
            DataSeries(
              name: 'Pipes',
              data: histogram.counts.map((c) => c.toDouble()).toList(),
            ),
          ],
          labels: histogram.labels,
          xAxis: const AxisOptions(label: 'Frequency (Hz, log scale)'),
          yAxis: const AxisOptions(label: 'Pipe count'),
          barChar: '█',
        ),
      ),
    );
    print('');
  }

  if (charts.contains('breaks')) {
    print(
      _renderRankLinesChart(
        keys: keys,
        composition: composition,
        lines: lines,
        allFrequencies: frequencies,
        width: width,
        height: int.parse(results.option('line-height')!),
        title: '$title — pitch vs. frequency (log)',
        colorMode: _ColorMode.values.byName(results.option('color-by')!),
        drawConnectors: results.flag('connectors'),
      ),
    );
  }

  print(
    '${frequencies.length} pipes across ${keys.length} keys '
    '(${from.format()}–${to.format()}), ${composition.length} rows.',
  );
}

ArgParser _buildParser() => ArgParser()
  ..addOption(
    'file',
    abbr: 'f',
    help:
        'Stop composition file (one breakpoint + ranks per line). '
        'Defaults to a Fourniture IV-style mixture.',
  )
  ..addOption(
    'from',
    defaultsTo: Keyboard.defaultExtension.from.format(),
    help: 'Lowest keyboard key.',
  )
  ..addOption(
    'to',
    defaultsTo: Keyboard.defaultExtension.to.format(),
    help: 'Highest keyboard key.',
  )
  ..addOption(
    'bins-per-octave',
    defaultsTo: '6',
    help: 'Frequency-distribution chart resolution, in bins per octave.',
  )
  ..addOption(
    'width',
    defaultsTo: '96',
    help: 'Chart width in terminal columns (both charts).',
  )
  ..addOption(
    'height',
    defaultsTo: '22',
    help: 'Frequency-distribution chart height in terminal rows.',
  )
  ..addOption(
    'line-height',
    defaultsTo: '26',
    help: 'Pitch/frequency line chart height in terminal rows.',
  )
  ..addOption('title', help: 'Chart title.')
  ..addFlag(
    'connectors',
    defaultsTo: true,
    help:
        'Draw a muted connector between two consecutive keys of the same '
        'rank when they land more than a couple of columns apart. Real '
        'pipes are always drawn as ●/⬤ on top, never hidden — disable '
        "this if it still reads as noise (it's skipped automatically for "
        'short, near-adjacent gaps).',
  )
  ..addOption(
    'color-by',
    defaultsTo: 'breakpoint',
    allowed: ['breakpoint', 'rank'],
    help:
        "How to colour the pitch/frequency chart's lines: one colour per "
        'PipeRow breakpoint (default), or one colour per rank position '
        "within its row (a row's 1st rank, 2nd rank, etc.).",
  )
  ..addMultiOption(
    'charts',
    defaultsTo: ['distribution', 'breaks'],
    allowed: ['distribution', 'breaks'],
    help: 'Which chart(s) to render.',
  )
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.');

/// How `_renderRankLinesChart` assigns a colour to each [_RankLine].
enum _ColorMode {
  /// One colour per [PipeRow] (breakpoint segment); every rank of that row
  /// shares it.
  breakpoint,

  /// One colour per rank *position* within its row (a row's 1st rank, 2nd
  /// rank, …), so the same "slot" reads as the same colour across breaks
  /// even though the row composition — and so what occupies that slot —
  /// can change at each breakpoint.
  rank,
}

/// One rank's frequency, as `(keyIndex, hertz)` points, across every key
/// where [row] is the applicable [PipeRow] (see [StopComposition.rowFor].
class _RankLine {
  const _RankLine(this.row, this.rankIndex, this.points);

  final PipeRow row;
  final int rankIndex;
  final List<(int, double)> points;
}

/// Builds one [_RankLine] per rank of every [PipeRow] in [composition],
/// restricted to the contiguous run of [keys] where that row applies.
List<_RankLine> _buildRankLines(List<PipeRow> composition, List<Pitch> keys) {
  final rowAt = [for (final key in keys) composition.rowFor(key)];

  final lines = <_RankLine>[];
  for (final row in composition) {
    final indices = [
      for (var i = 0; i < keys.length; i++)
        if (rowAt[i] == row) i,
    ];
    if (indices.isEmpty) continue;

    final intervals = row.rankIntervals;
    for (var rankIndex = 0; rankIndex < intervals.length; rankIndex++) {
      final interval = intervals[rankIndex];
      final points = [
        for (final i in indices)
          (i, keys[i].transposeBy(interval).frequency().hertz.toDouble()),
      ];
      lines.add(_RankLine(row, rankIndex, points));
    }
  }

  return lines;
}

/// A histogram of `frequencies` binned on an evenly-spaced log2 (octave)
/// scale, so that equal musical intervals (e.g. every fifth, every octave)
/// occupy equal chart width regardless of the absolute pitch height.
class _LogHistogram {
  _LogHistogram(List<double> frequencies, {required this.binsPerOctave})
    : assert(frequencies.isNotEmpty, 'frequencies must not be empty'),
      assert(binsPerOctave > 0, 'binsPerOctave must be positive') {
    final logValues = frequencies.map(_log2).toList()..sort();
    final binWidth = 1 / binsPerOctave;
    final startBin = (logValues.first / binWidth).floor();
    final endBin = (logValues.last / binWidth).floor() + 1;
    final binCount = math.max(1, endBin - startBin);

    final counts = List<int>.filled(binCount, 0);
    for (final value in logValues) {
      final index = ((value / binWidth).floor() - startBin).clamp(
        0,
        binCount - 1,
      );
      counts[index]++;
    }

    this.counts = counts;
    labels = List<String>.generate(binCount, (i) {
      final hertz = math.pow(2, (startBin + i) * binWidth).toDouble();
      return _formatHertzShort(hertz);
    });
  }

  final int binsPerOctave;
  late final List<int> counts;
  late final List<String> labels;
}

double _log2(double value) => math.log(value) / math.ln2;

/// Roman-numeral rank subtraction pairs, from largest to smallest — the
/// standard way mixture ranks are labelled (Mixture IV, Rank I, II, …).
const _romanNumeralValues = [
  (1000, 'M'),
  (900, 'CM'),
  (500, 'D'),
  (400, 'CD'),
  (100, 'C'),
  (90, 'XC'),
  (50, 'L'),
  (40, 'XL'),
  (10, 'X'),
  (9, 'IX'),
  (5, 'V'),
  (4, 'IV'),
  (1, 'I'),
];

String _romanNumeral(int number) {
  var remainder = number;
  final buffer = StringBuffer();
  for (final (value, symbol) in _romanNumeralValues) {
    while (remainder >= value) {
      buffer.write(symbol);
      remainder -= value;
    }
  }

  return buffer.toString();
}

/// A short axis label, e.g. `98.4`, `440`, `1.2k`.
String _formatHertzShort(double hertz) => switch (hertz) {
  >= 1000 => '${(hertz / 1000).toStringAsFixed(1)}k',
  >= 100 => hertz.toStringAsFixed(0),
  _ => hertz.toStringAsFixed(1),
};

/// A gridline label using a period as the thousands separator, e.g. `100
/// Hz`, `1.000 Hz`, `10.000 Hz`.
String _formatHertzEu(num hertz) {
  final digits = hertz.round().toString();
  final buffer = StringBuffer();
  final firstGroupLength = digits.length % 3 == 0 ? 3 : digits.length % 3;
  buffer.write(digits.substring(0, firstGroupLength));
  for (var i = firstGroupLength; i < digits.length; i += 3) {
    buffer
      ..write('.')
      ..write(digits.substring(i, i + 3));
  }

  return '$buffer Hz';
}

/// Renders a pitch (x) vs. log-frequency (y) chart. [colorMode] controls
/// whether lines are coloured by [PipeRow] breakpoint or by rank position;
/// [allFrequencies] sets the shared y-axis domain.
///
/// When [drawConnectors] is true, a muted, dimmed connector is drawn
/// between two consecutive keys of the same rank *only* when they land
/// more than a couple of columns apart (short, near-adjacent gaps are
/// skipped, since with more plot columns than keys — the common case —
/// they'd otherwise fire on almost every key and outnumber the real
/// pipes). Real data points are always drawn last, in the rank's own
/// colour and sized by duplicate count, so a connector never hides one.
String _renderRankLinesChart({
  required List<Pitch> keys,
  required List<PipeRow> composition,
  required List<_RankLine> lines,
  required List<double> allFrequencies,
  required int width,
  required int height,
  required String title,
  required _ColorMode colorMode,
  required bool drawConnectors,
}) {
  const yLabelWidth = 10;
  final plotWidth = math.max(10, width - yLabelWidth);
  final plotHeight = math.max(5, height - 3);

  final minHertz = allFrequencies.reduce(math.min);
  final maxHertz = allFrequencies.reduce(math.max);
  final logMin = _log2(minHertz);
  final logMax = _log2(maxHertz);
  final logSpan = logMax == logMin ? 1.0 : logMax - logMin;

  int xFor(int keyIndex) => keys.length <= 1
      ? 0
      : (keyIndex / (keys.length - 1) * (plotWidth - 1)).round();
  int yFor(double hertz) =>
      (plotHeight - 1) -
      (((_log2(hertz) - logMin) / logSpan) * (plotHeight - 1)).round();

  int colorIndexFor(_RankLine line) => switch (colorMode) {
    _ColorMode.breakpoint => composition.indexOf(line.row),
    _ColorMode.rank => line.rankIndex,
  };

  // How many ranks land on the exact same (key, pitch) — same computation,
  // same key, so exact `==` is safe — regardless of which row or rank
  // slot they came from.
  final duplicateCounts = <(int, double), int>{};
  for (final line in lines) {
    for (final point in line.points) {
      duplicateCounts.update(point, (n) => n + 1, ifAbsent: () => 1);
    }
  }

  final canvas = List.generate(plotHeight, (_) => List.filled(plotWidth, ' '));
  final colors = List.generate(
    plotHeight,
    (_) => List<int?>.filled(plotWidth, null),
  );
  final emphasis = List.generate(
    plotHeight,
    (_) => List<bool>.filled(plotWidth, false),
  );

  void plot(int x, int y, String char, int color, {bool bold = false}) {
    if (x < 0 || x >= plotWidth || y < 0 || y >= plotHeight) return;
    canvas[y][x] = char;
    colors[y][x] = color;
    emphasis[y][x] = bold;
  }

  // Pass 1: muted connectors between consecutive points of the same rank,
  // skipped for short gaps (adjacent-ish keys don't need a hint) so they
  // can't outnumber the real pipes at typical width/keyboard proportions.
  const connectorColor = 90; // bright black / grey: recedes behind markers
  const minGapForConnector = 3;
  if (drawConnectors) {
    for (final line in lines) {
      for (var p = 0; p < line.points.length - 1; p++) {
        final (x0, y0) = (xFor(line.points[p].$1), yFor(line.points[p].$2));
        final (x1, y1) = (
          xFor(line.points[p + 1].$1),
          yFor(line.points[p + 1].$2),
        );
        final steps = math.max((x1 - x0).abs(), (y1 - y0).abs());
        if (steps < minGapForConnector) continue;
        for (var s = 1; s < steps; s++) {
          final t = s / steps;
          plot(
            (x0 + (x1 - x0) * t).round(),
            (y0 + (y1 - y0) * t).round(),
            '·',
            connectorColor,
          );
        }
      }
    }
  }

  // Pass 2: the real data points, drawn last so a connector never hides
  // one, sized by how many ranks share that exact pitch.
  for (final line in lines) {
    final color = _palette[colorIndexFor(line) % _palette.length];
    for (final point in line.points) {
      final count = duplicateCounts[point]!;
      plot(
        xFor(point.$1),
        yFor(point.$2),
        count >= 2 ? '⬤' : '●',
        color,
        bold: count >= 3,
      );
    }
  }

  final buffer = StringBuffer(title)..writeln();

  // Y-axis: one gridline label per "nice" Hz value that lands in range.
  final yTicks = <int, String>{};
  for (final hertz in _niceHertz) {
    if (hertz < minHertz * 0.95 || hertz > maxHertz * 1.05) continue;
    final row = yFor(hertz.toDouble());
    if (row < 0 || row >= plotHeight) continue;
    yTicks.putIfAbsent(row, () => _formatHertzEu(hertz));
  }

  for (var y = 0; y < plotHeight; y++) {
    final label = (yTicks[y] ?? '').padLeft(yLabelWidth - 1);
    buffer.write('$label ');
    for (var x = 0; x < plotWidth; x++) {
      final char = canvas[y][x];
      final color = colors[y][x];
      final sgr = emphasis[y][x] ? '1;$color' : '$color';
      buffer.write(color == null ? char : '\x1B[${sgr}m$char\x1B[0m');
    }
    buffer.writeln();
  }

  // X-axis: every natural C (one per octave), plus both keyboard ends.
  final xLabelRow = List.filled(yLabelWidth + plotWidth, ' ');
  void placeLabel(int keyIndex) {
    final label = keys[keyIndex].format();
    final column = yLabelWidth + xFor(keyIndex);
    for (var i = 0; i < label.length && column + i < xLabelRow.length; i++) {
      xLabelRow[column + i] = label[i];
    }
  }

  placeLabel(0);
  placeLabel(keys.length - 1);
  for (var i = 0; i < keys.length; i++) {
    final Note(:noteName, :accidental) = keys[i].note;
    if (noteName == NoteName.c && accidental.isNatural) placeLabel(i);
  }
  buffer
    ..writeln(xLabelRow.join())
    ..writeln(
      '\n● one pipe here   ⬤ two unison-duplicated ranks   '
      '\x1B[1m⬤\x1B[0m three or more   '
      '\x1B[90m·\x1B[0m connector (not a pipe)',
    )
    ..writeln();
  switch (colorMode) {
    case .breakpoint:
      buffer.writeln(
        composition.format(
          StopCompositionNotation(
            leading: (i, row) =>
                '\x1B[${_palette[i % _palette.length]}m■\x1B[0m',
          ),
        ),
      );
    case .rank:
      final maxRanks = composition
          .map((row) => row.ranks.length)
          .reduce(math.max);
      for (var i = 0; i < maxRanks; i++) {
        final color = _palette[i % _palette.length];
        final feet = [
          for (final row in composition)
            if (i < row.ranks.length) '${row.ranks[i]}′',
        ].join(', ');
        buffer.writeln(
          '\x1B[${color}m■\x1B[0m Rank ${_romanNumeral(i + 1)}: $feet',
        );
      }
  }

  return buffer.toString();
}
