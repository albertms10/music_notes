import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('PositionedNote', () {
    group('.semitonesFromRootHeight', () {
      test(
        'should return the semitones from the root height of this '
        'PositionedNote',
        () {
          expect(Note.c.inOctave(0).semitonesFromRootHeight, 1);
          expect(Note.c.inOctave(1).semitonesFromRootHeight, 13);
          expect(Note.c.inOctave(2).semitonesFromRootHeight, 25);
          expect(Note.a.inOctave(2).semitonesFromRootHeight, 34);
          expect(Note.a.inOctave(4).semitonesFromRootHeight, 58);
        },
      );
    });

    group('.difference()', () {
      test(
        'should return the difference in semitones with another PositionedNote',
        () {
          expect(Note.c.inOctave(4).difference(Note.c.inOctave(4)), 0);
          expect(
            const Note(Notes.e, Accidental.sharp)
                .difference(Note.f.inOctave(4)),
            0,
          );
          expect(Note.c.inOctave(4).difference(Note.dFlat.inOctave(4)), 1);
          expect(Note.c.inOctave(4).difference(Note.cSharp.inOctave(4)), 1);
          expect(
            Note.b.inOctave(4).difference(Note.c.inOctave(4).inOctave(5)),
            1,
          );
          expect(Note.f.inOctave(4).difference(Note.g.inOctave(4)), 2);
          expect(Note.f.inOctave(4).difference(Note.aFlat.inOctave(4)), 3);
          expect(Note.e.inOctave(4).difference(Note.aFlat.inOctave(4)), 4);
          expect(
            Note.a.inOctave(4).difference(Note.d.inOctave(4).inOctave(5)),
            5,
          );
          expect(Note.d.inOctave(4).difference(Note.aFlat.inOctave(4)), 6);
          expect(Note.eFlat.inOctave(4).difference(Note.bFlat.inOctave(4)), 7);
          expect(
            Note.dSharp.inOctave(4).difference(Note.aSharp.inOctave(4)),
            7,
          );
          expect(Note.d.inOctave(4).difference(Note.aSharp.inOctave(4)), 8);
          expect(Note.cSharp.inOctave(4).difference(Note.bFlat.inOctave(4)), 9);
          expect(Note.cSharp.inOctave(4).difference(Note.b.inOctave(4)), 10);
          expect(Note.dFlat.inOctave(4).difference(Note.b.inOctave(4)), 10);
          expect(Note.c.inOctave(4).difference(Note.b.inOctave(4)), 11);
        },
      );
    });

    group('.equalTemperamentFrequency()', () {
      test('should return the hertzs of this PositionedNote from 440 Hz', () {
        expect(
          Note.c.inOctave(4).equalTemperamentFrequency(),
          closeTo(261.63, 0.01),
        );
        expect(
          Note.cSharp.inOctave(4).equalTemperamentFrequency(),
          closeTo(277.18, 0.01),
        );
        expect(
          Note.dFlat.inOctave(4).equalTemperamentFrequency(),
          closeTo(277.18, 0.01),
        );
        expect(
          Note.d.inOctave(4).equalTemperamentFrequency(),
          closeTo(293.66, 0.01),
        );
        expect(
          Note.dSharp.inOctave(4).equalTemperamentFrequency(),
          closeTo(311.13, 0.01),
        );
        expect(
          Note.eFlat.inOctave(4).equalTemperamentFrequency(),
          closeTo(311.13, 0.01),
        );
        expect(
          Note.e.inOctave(4).equalTemperamentFrequency(),
          closeTo(329.63, 0.01),
        );
        expect(
          Note.f.inOctave(4).equalTemperamentFrequency(),
          closeTo(349.23, 0.01),
        );
        expect(
          Note.fSharp.inOctave(4).equalTemperamentFrequency(),
          closeTo(369.99, 0.01),
        );
        expect(
          Note.gFlat.inOctave(4).equalTemperamentFrequency(),
          closeTo(369.99, 0.01),
        );
        expect(
          Note.g.inOctave(4).equalTemperamentFrequency(),
          closeTo(392, 0.01),
        );
        expect(
          Note.gSharp.inOctave(4).equalTemperamentFrequency(),
          closeTo(415.3, 0.01),
        );
        expect(
          Note.aFlat.inOctave(4).equalTemperamentFrequency(),
          closeTo(415.3, 0.01),
        );
        expect(Note.a.inOctave(4).equalTemperamentFrequency(), 440);
        expect(
          Note.aSharp.inOctave(4).equalTemperamentFrequency(),
          closeTo(466.16, 0.01),
        );
        expect(
          Note.bFlat.inOctave(4).equalTemperamentFrequency(),
          closeTo(466.16, 0.01),
        );
        expect(
          Note.b.inOctave(4).equalTemperamentFrequency(),
          closeTo(493.88, 0.01),
        );
      });

      test('should return the hertzs of this PositionedNote from 438 Hz', () {
        expect(
          Note.c.inOctave(4).equalTemperamentFrequency(438),
          closeTo(260.44, 0.01),
        );
        expect(
          Note.cSharp.inOctave(4).equalTemperamentFrequency(438),
          closeTo(275.92, 0.01),
        );
        expect(
          Note.dFlat.inOctave(4).equalTemperamentFrequency(438),
          closeTo(275.92, 0.01),
        );
        expect(
          Note.d.inOctave(4).equalTemperamentFrequency(438),
          closeTo(292.33, 0.01),
        );
        expect(
          Note.dSharp.inOctave(4).equalTemperamentFrequency(438),
          closeTo(309.71, 0.01),
        );
        expect(
          Note.eFlat.inOctave(4).equalTemperamentFrequency(438),
          closeTo(309.71, 0.01),
        );
        expect(
          Note.e.inOctave(4).equalTemperamentFrequency(438),
          closeTo(328.13, 0.01),
        );
        expect(
          Note.f.inOctave(4).equalTemperamentFrequency(438),
          closeTo(347.64, 0.01),
        );
        expect(
          Note.fSharp.inOctave(4).equalTemperamentFrequency(438),
          closeTo(368.31, 0.01),
        );
        expect(
          Note.gFlat.inOctave(4).equalTemperamentFrequency(438),
          closeTo(368.31, 0.01),
        );
        expect(
          Note.g.inOctave(4).equalTemperamentFrequency(438),
          closeTo(390.21, 0.01),
        );
        expect(
          Note.gSharp.inOctave(4).equalTemperamentFrequency(438),
          closeTo(413.42, 0.01),
        );
        expect(
          Note.aFlat.inOctave(4).equalTemperamentFrequency(438),
          closeTo(413.42, 0.01),
        );
        expect(Note.a.inOctave(4).equalTemperamentFrequency(438), 438);
        expect(
          Note.aSharp.inOctave(4).equalTemperamentFrequency(438),
          closeTo(464.04, 0.01),
        );
        expect(
          Note.bFlat.inOctave(4).equalTemperamentFrequency(438),
          closeTo(464.04, 0.01),
        );
        expect(
          Note.b.inOctave(4).equalTemperamentFrequency(438),
          closeTo(491.64, 0.01),
        );
      });
    });

    group('.isHumanAudible', () {
      test('should return whether this PositionedNote is human-audible', () {
        expect(Note.c.inOctave(4).isHumanAudible, isTrue);
        expect(Note.a.inOctave(2).isHumanAudible, isTrue);
        expect(Note.d.inOctave(0).isHumanAudible, isFalse);
        expect(Note.d.inOctave(12).isHumanAudible, isFalse);
      });
    });

    group('.scientificName', () {
      test(
        'should return the scientific pitch notation name for this '
        'PositionedNote',
        () {
          expect(Note.gSharp.inOctave(-1).scientificName, 'G♯-1');
          expect(Note.d.inOctave(0).scientificName, 'D0');
          expect(Note.bFlat.inOctave(1).scientificName, 'B♭1');
          expect(Note.g.inOctave(2).scientificName, 'G2');
          expect(Note.a.inOctave(3).scientificName, 'A3');
          expect(Note.c.inOctave(4).scientificName, 'C4');
          expect(Note.cSharp.inOctave(4).scientificName, 'C♯4');
          expect(Note.a.inOctave(4).scientificName, 'A4');
          expect(Note.fSharp.inOctave(5).scientificName, 'F♯5');
          expect(Note.e.inOctave(7).scientificName, 'E7');
        },
      );
    });

    group('.helmholtzName', () {
      test(
        'should return the Helmholtz pitch notation name for this '
        'PositionedNote',
        () {
          expect(Note.gSharp.inOctave(-1).helmholtzName, 'G♯͵͵͵');
          expect(Note.d.inOctave(0).helmholtzName, 'D͵͵');
          expect(Note.bFlat.inOctave(1).helmholtzName, 'B♭͵');
          expect(Note.g.inOctave(2).helmholtzName, 'G');
          expect(Note.a.inOctave(3).helmholtzName, 'a');
          expect(Note.c.inOctave(4).helmholtzName, 'c′');
          expect(Note.cSharp.inOctave(4).helmholtzName, 'c♯′');
          expect(Note.a.inOctave(4).helmholtzName, 'a′');
          expect(Note.fSharp.inOctave(5).helmholtzName, 'f♯′′');
          expect(Note.e.inOctave(7).helmholtzName, 'e′′′′');
        },
      );
    });

    group('.toString()', () {
      test(
        'should return the string representation of this PositionedNote',
        () {
          expect(Note.dSharp.inOctave(0).toString(), 'D♯0');
          expect(Note.eFlat.inOctave(2).toString(), 'E♭2');
          expect(Note.a.inOctave(4).toString(), 'A4');
          expect(Note.fSharp.inOctave(4).toString(), 'F♯4');
          expect(Note.g.inOctave(7).toString(), 'G7');
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal PositionedNote instances in a Set', () {
        final collection = {
          Note.c.inOctave(4),
          Note.aFlat.inOctave(2),
          Note.gSharp.inOctave(5),
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.c.inOctave(4),
          Note.aFlat.inOctave(2),
          Note.gSharp.inOctave(5),
        ]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort PositionedNote items in a collection', () {
        final orderedSet = SplayTreeSet<PositionedNote>.of([
          Note.aFlat.inOctave(4),
          Note.bFlat.inOctave(5),
          Note.c.inOctave(4),
          Note.d.inOctave(2),
          Note.gSharp.inOctave(4),
          const Note(Notes.b, Accidental.sharp).inOctave(4),
        ]);
        expect(orderedSet.toList(), [
          Note.d.inOctave(2),
          Note.c.inOctave(4),
          const Note(Notes.b, Accidental.sharp).inOctave(4),
          Note.gSharp.inOctave(4),
          Note.aFlat.inOctave(4),
          Note.bFlat.inOctave(5),
        ]);
      });
    });
  });
}
