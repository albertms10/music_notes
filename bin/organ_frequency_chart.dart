// ignore_for_file: avoid_print CLI

// A CLI tool for visualising a music_notes organ stop composition
// (a `List<PipeRow>`, from the work-in-progress `organ` branch) in the
// terminal:
//
//   1. A log-frequency histogram of every pipe sounded across a keyboard
//      (see `_LogHistogram`), rendered with `package:artisanal`.
//   2. A pitch (x) vs. frequency-in-Hz-on-a-log-scale (y) chart with one
//      line per `PipeRow` (each row gets its own colour; a row with
//      several ranks draws several same-coloured lines), rendered with a
//      small purpose-built ANSI renderer (see `_renderRankLinesChart`).
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
// With no --file given, a Fourniture IV-style mixture (straight from the
// PipeRow.parse doc comment) is used.
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
        title: '$title — pitch vs. frequency (log), one colour per row',
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
  ..addMultiOption(
    'charts',
    defaultsTo: ['distribution', 'breaks'],
    allowed: ['distribution', 'breaks'],
    help: 'Which chart(s) to render.',
  )
  ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.');

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

/// Renders a pitch (x) vs. log-frequency (y) chart with one colour per
/// [PipeRow] in [composition] — every rank of a row is drawn in that row's
/// colour, so a row with several ranks shows as several same-coloured
/// lines. [allFrequencies] sets the shared y-axis domain.
String _renderRankLinesChart({
  required List<Pitch> keys,
  required List<PipeRow> composition,
  required List<_RankLine> lines,
  required List<double> allFrequencies,
  required int width,
  required int height,
  required String title,
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

  final canvas = List.generate(plotHeight, (_) => List.filled(plotWidth, ' '));
  final colors = List.generate(
    plotHeight,
    (_) => List<int?>.filled(plotWidth, null),
  );

  void plot(int x, int y, int color) {
    if (x < 0 || x >= plotWidth || y < 0 || y >= plotHeight) return;
    canvas[y][x] = '●';
    colors[y][x] = color;
  }

  void drawSegment(
    (int, double) a,
    (int, double) b,
    int color,
  ) {
    final x0 = xFor(a.$1);
    final y0 = yFor(a.$2);
    final x1 = xFor(b.$1);
    final y1 = yFor(b.$2);
    final steps = math
        .max((x1 - x0).abs(), (y1 - y0).abs())
        .clamp(
          1,
          plotWidth,
        );
    for (var s = 0; s <= steps; s++) {
      final t = s / steps;
      plot((x0 + (x1 - x0) * t).round(), (y0 + (y1 - y0) * t).round(), color);
    }
  }

  for (final line in lines) {
    final color = _palette[composition.indexOf(line.row) % _palette.length];
    if (line.points.length == 1) {
      final (x, hertz) = line.points.single;
      plot(xFor(x), yFor(hertz), color);
      continue;
    }
    for (var p = 0; p < line.points.length - 1; p++) {
      drawSegment(line.points[p], line.points[p + 1], color);
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
      buffer.write(color == null ? char : '\x1B[${color}m$char\x1B[0m');
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
    ..writeln()
    ..write(
      composition.format(
        StopCompositionNotation(
          leading: (i, row) => '\x1B[${_palette[i % _palette.length]}m■\x1B[0m',
        ),
      ),
    );

  return buffer.toString();
}
