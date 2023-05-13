import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('PositionedNote', () {
    group('.octaveFromSemitones', () {
      test(
        'should return the octave that corresponds to the semitones from root '
        'height',
        () {
          expect(PositionedNote.octaveFromSemitones(-35), -3);
          expect(PositionedNote.octaveFromSemitones(-23), -2);
          expect(PositionedNote.octaveFromSemitones(-11), -1);
          expect(PositionedNote.octaveFromSemitones(-1), -1);
          // TODO(albertms10): Should 0 be considered a correct argument?
          expect(PositionedNote.octaveFromSemitones(0), 0);
          expect(PositionedNote.octaveFromSemitones(1), 0);
          expect(PositionedNote.octaveFromSemitones(13), 1);
          expect(PositionedNote.octaveFromSemitones(25), 2);
          expect(PositionedNote.octaveFromSemitones(34), 2);
          expect(PositionedNote.octaveFromSemitones(58), 4);
        },
      );
    });

    group('.semitonesFromRootHeight', () {
      test(
        'should return the semitones from the root height of this '
        'PositionedNote',
        () {
          expect(Note.c.inOctave(-4).semitonesFromRootHeight, -47);
          expect(Note.a.inOctave(-4).semitonesFromRootHeight, -38);
          expect(Note.c.inOctave(-3).semitonesFromRootHeight, -35);
          expect(Note.c.inOctave(-2).semitonesFromRootHeight, -23);
          expect(Note.c.inOctave(-1).semitonesFromRootHeight, -11);
          expect(Note.c.inOctave(0).semitonesFromRootHeight, 1);
          expect(Note.c.inOctave(1).semitonesFromRootHeight, 13);
          expect(Note.c.inOctave(2).semitonesFromRootHeight, 25);
          expect(Note.a.inOctave(2).semitonesFromRootHeight, 34);
          expect(Note.c.inOctave(3).semitonesFromRootHeight, 37);
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

    group('.transposeBy()', () {
      test('should return this PositionedNote transposed by Interval', () {
        expect(
          Note.c.inOctave(4).transposeBy(Interval.diminishedUnison),
          const Note(Notes.c, Accidental.flat).inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.diminishedUnison),
          Note.cSharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(3).transposeBy(Interval.perfectUnison),
          Note.c.inOctave(3),
        );
        expect(
          Note.c.inOctave(3).transposeBy(-Interval.perfectUnison),
          Note.c.inOctave(3),
        );
        expect(
          Note.c.inOctave(5).transposeBy(Interval.augmentedUnison),
          Note.cSharp.inOctave(5),
        );
        expect(
          Note.c.inOctave(5).transposeBy(-Interval.augmentedUnison),
          const Note(Notes.c, Accidental.flat).inOctave(5),
        );

        expect(
          Note.c.inOctave(4).transposeBy(Interval.diminishedSecond),
          const Note(Notes.d, Accidental.doubleFlat).inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.diminishedSecond),
          const Note(Notes.b, Accidental.sharp).inOctave(3),
        );
        expect(
          Note.c.inOctave(6).transposeBy(Interval.minorSecond),
          Note.dFlat.inOctave(6),
        );
        expect(
          Note.c.inOctave(6).transposeBy(-Interval.minorSecond),
          Note.b.inOctave(5),
        );
        expect(
          Note.c.inOctave(-1).transposeBy(Interval.majorSecond),
          Note.d.inOctave(-1),
        );
        expect(
          Note.c.inOctave(-1).transposeBy(-Interval.majorSecond),
          Note.bFlat.inOctave(-2),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.augmentedSecond),
          Note.dSharp.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.augmentedSecond),
          const Note(Notes.b, Accidental.doubleFlat).inOctave(3),
        );

        expect(
          Note.e.inOctave(2).transposeBy(Interval.minorThird),
          Note.g.inOctave(2),
        );
        expect(
          Note.e.inOctave(2).transposeBy(-Interval.minorThird),
          Note.cSharp.inOctave(2),
        );
        expect(
          Note.e.inOctave(4).transposeBy(Interval.majorThird),
          Note.gSharp.inOctave(4),
        );
        expect(
          Note.e.inOctave(4).transposeBy(-Interval.majorThird),
          Note.c.inOctave(4),
        );
        expect(
          Note.aFlat.inOctave(4).transposeBy(Interval.minorThird),
          const Note(Notes.c, Accidental.flat).inOctave(5),
        );
        expect(
          Note.aFlat.inOctave(4).transposeBy(-Interval.minorThird),
          Note.f.inOctave(4),
        );
        expect(
          Note.aFlat.inOctave(4).transposeBy(Interval.majorThird),
          Note.c.inOctave(5),
        );
        expect(
          Note.aFlat.inOctave(4).transposeBy(-Interval.majorThird),
          const Note(Notes.f, Accidental.flat).inOctave(4),
        );

        expect(
          Note.f.inOctave(4).transposeBy(Interval.diminishedFourth),
          const Note(Notes.b, Accidental.doubleFlat).inOctave(4),
        );
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.diminishedFourth),
          Note.cSharp.inOctave(4),
        );
        expect(
          Note.f.inOctave(3).transposeBy(Interval.perfectFourth),
          Note.bFlat.inOctave(3),
        );
        expect(
          Note.f.inOctave(3).transposeBy(-Interval.perfectFourth),
          Note.c.inOctave(3),
        );
        expect(
          Note.f.inOctave(4).transposeBy(Interval.augmentedFourth),
          Note.b.inOctave(4),
        );
        expect(
          Note.f.inOctave(4).transposeBy(-Interval.augmentedFourth),
          const Note(Notes.c, Accidental.flat).inOctave(4),
        );
        expect(
          Note.a.inOctave(6).transposeBy(Interval.diminishedFourth),
          Note.dFlat.inOctave(7),
        );
        expect(
          Note.a.inOctave(6).transposeBy(-Interval.diminishedFourth),
          const Note(Notes.e, Accidental.sharp).inOctave(6),
        );
        expect(
          Note.a.inOctave(-2).transposeBy(Interval.perfectFourth),
          Note.d.inOctave(-1),
        );
        expect(
          Note.a.inOctave(-2).transposeBy(-Interval.perfectFourth),
          Note.e.inOctave(-2),
        );
        expect(
          Note.a.inOctave(7).transposeBy(Interval.augmentedFourth),
          Note.dSharp.inOctave(8),
        );
        expect(
          Note.a.inOctave(7).transposeBy(-Interval.augmentedFourth),
          Note.eFlat.inOctave(7),
        );

        expect(
          Note.d.inOctave(4).transposeBy(Interval.diminishedFifth),
          Note.aFlat.inOctave(4),
        );
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.diminishedFifth),
          Note.gSharp.inOctave(3),
        );
        expect(
          Note.d.inOctave(1).transposeBy(Interval.perfectFifth),
          Note.a.inOctave(1),
        );
        expect(
          Note.d.inOctave(1).transposeBy(-Interval.perfectFifth),
          Note.g.inOctave(0),
        );
        expect(
          Note.d.inOctave(2).transposeBy(Interval.augmentedFifth),
          Note.aSharp.inOctave(2),
        );
        expect(
          Note.d.inOctave(2).transposeBy(-Interval.augmentedFifth),
          Note.gFlat.inOctave(1),
        );

        expect(
          Note.d.inOctave(4).transposeBy(Interval.minorSixth),
          Note.bFlat.inOctave(4),
        );
        expect(
          Note.d.inOctave(4).transposeBy(-Interval.minorSixth),
          Note.fSharp.inOctave(3),
        );
        expect(
          Note.d.inOctave(-2).transposeBy(Interval.majorSixth),
          Note.b.inOctave(-2),
        );
        expect(
          Note.d.inOctave(-2).transposeBy(-Interval.majorSixth),
          Note.f.inOctave(-3),
        );
        expect(
          Note.fSharp.inOctave(4).transposeBy(Interval.minorSixth),
          Note.d.inOctave(5),
        );
        expect(
          Note.fSharp.inOctave(4).transposeBy(-Interval.minorSixth),
          Note.aSharp.inOctave(3),
        );
        expect(
          Note.fSharp.inOctave(-1).transposeBy(Interval.majorSixth),
          Note.dSharp.inOctave(0),
        );
        expect(
          Note.fSharp.inOctave(-1).transposeBy(-Interval.majorSixth),
          Note.a.inOctave(-2),
        );

        expect(
          Note.c.inOctave(0).transposeBy(Interval.minorSeventh),
          Note.bFlat.inOctave(0),
        );
        expect(
          Note.c.inOctave(0).transposeBy(-Interval.minorSeventh),
          Note.d.inOctave(-1),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.majorSeventh),
          Note.b.inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.majorSeventh),
          Note.dFlat.inOctave(3),
        );
        expect(
          Note.c.inOctave(4).transposeBy(Interval.augmentedSeventh),
          const Note(Notes.b, Accidental.sharp).inOctave(4),
        );
        expect(
          Note.c.inOctave(4).transposeBy(-Interval.augmentedSeventh),
          const Note(Notes.d, Accidental.doubleFlat).inOctave(3),
        );
      });
    });

    group('.equalTemperamentFrequency()', () {
      test(
        'should return the Frequency of this PositionedNote from 440 Hz',
        () {
          expect(
            Note.c.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(261.63, 0.01),
          );
          expect(
            Note.cSharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(277.18, 0.01),
          );
          expect(
            Note.dFlat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(277.18, 0.01),
          );
          expect(
            Note.d.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(293.66, 0.01),
          );
          expect(
            Note.dSharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(311.13, 0.01),
          );
          expect(
            Note.eFlat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(311.13, 0.01),
          );
          expect(
            Note.e.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(329.63, 0.01),
          );
          expect(
            Note.f.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(349.23, 0.01),
          );
          expect(
            Note.fSharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(369.99, 0.01),
          );
          expect(
            Note.gFlat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(369.99, 0.01),
          );
          expect(
            Note.g.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(392, 0.01),
          );
          expect(
            Note.gSharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(415.3, 0.01),
          );
          expect(
            Note.aFlat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(415.3, 0.01),
          );
          expect(Note.a.inOctave(4).equalTemperamentFrequency().hertz, 440);
          expect(
            Note.aSharp.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(466.16, 0.01),
          );
          expect(
            Note.bFlat.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(466.16, 0.01),
          );
          expect(
            Note.b.inOctave(4).equalTemperamentFrequency().hertz,
            closeTo(493.88, 0.01),
          );
        },
      );

      test(
        'should return the Frequency of this PositionedNote from 438 Hz',
        () {
          expect(
            Note.c.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(260.44, 0.01),
          );
          expect(
            Note.cSharp.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(275.92, 0.01),
          );
          expect(
            Note.dFlat.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(275.92, 0.01),
          );
          expect(
            Note.d.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(292.33, 0.01),
          );
          expect(
            Note.dSharp.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(309.71, 0.01),
          );
          expect(
            Note.eFlat.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(309.71, 0.01),
          );
          expect(
            Note.e.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(328.13, 0.01),
          );
          expect(
            Note.f.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(347.64, 0.01),
          );
          expect(
            Note.fSharp.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(368.31, 0.01),
          );
          expect(
            Note.gFlat.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(368.31, 0.01),
          );
          expect(
            Note.g.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(390.21, 0.01),
          );
          expect(
            Note.gSharp.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(413.42, 0.01),
          );
          expect(
            Note.aFlat.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(413.42, 0.01),
          );
          expect(Note.a.inOctave(4).equalTemperamentFrequency(438).hertz, 438);
          expect(
            Note.aSharp.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(464.04, 0.01),
          );
          expect(
            Note.bFlat.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(464.04, 0.01),
          );
          expect(
            Note.b.inOctave(4).equalTemperamentFrequency(438).hertz,
            closeTo(491.64, 0.01),
          );
        },
      );
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
