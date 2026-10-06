// ignore_for_file: avoid_print CLI

import 'package:music_notes/utils.dart';
import 'package:pipe_organ/pipe_organ.dart';

final metzler2005 = Organ(
  stops: [
    OrganStop(
      name: 'Mixtur',
      composition: StopComposition.parse('''
C 1 1/3, 1, 2/3,
c 2, 1 1/3, 1,
g 2 2/3, 2, 1 1/3, 1,
c' 4, 2 2/3, 2, 1 1/3,
c'' 8, 4, 2 2/3, 2,
'''),
    ),
    OrganStop(
      name: 'Scharff',
      composition: StopComposition.parse('''
C 1, 2/3, 1/2
B 1 1/3, 1, 2/3
b 2, 1 1/3, 1
f' 2 2/3, 2, 1 1/3, 1
b' 4, 2 2/3, 2, 1 1/3
b' 4, 2 2/3, 2 2/3, 2
'''),
    ),
  ],
);

void main() {
  final Organ(:keyboards, :stops) = metzler2005;

  for (final key in keyboards.first.extension.explode()) {
    final row = stops.first.composition.rowFor(key);
    if (row == null) {
      print('skip ${key.format()};');
      continue;
    }
    final frequencies = row.rankIntervals
        .map((interval) => key.transposeBy(interval).frequency())
        .toList();

    print(
      '${key.format()};'
      '${frequencies.map((f) => f.hertz.toStringAsFixed(2)).join(';')};'
      '(${row.rankIntervals.length} ranks, row ${row.breakpoint.format()});',
    );
  }
}
