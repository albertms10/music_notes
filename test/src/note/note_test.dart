import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
    group('.semitones', () {
      test('should return the semitones value of this Note', () {
        expect(const Note(Notes.b, Accidental.sharp).semitones, 1);
        expect(Note.c.semitones, 1);
        expect(Note.cSharp.semitones, 2);
        expect(Note.dFlat.semitones, 2);
        expect(Note.d.semitones, 3);
        expect(Note.dSharp.semitones, 4);
        expect(Note.eFlat.semitones, 4);
        expect(Note.e.semitones, 5);
        expect(Note.f.semitones, 6);
        expect(Note.fSharp.semitones, 7);
        expect(Note.gFlat.semitones, 7);
        expect(Note.g.semitones, 8);
        expect(Note.gSharp.semitones, 9);
        expect(Note.aFlat.semitones, 9);
        expect(Note.a.semitones, 10);
        expect(Note.aSharp.semitones, 11);
        expect(Note.bFlat.semitones, 11);
        expect(Note.b.semitones, 12);
        expect(const Note(Notes.c, Accidental.flat).semitones, 12);
      });
    });

    group('.semitonesFromRootHeight', () {
      test(
        'should return the semitones from the root height of this Note',
        () {
          expect(Note.c.inOctave(0).semitonesFromRootHeight, 1);
          expect(Note.c.inOctave(1).semitonesFromRootHeight, 13);
          expect(Note.c.inOctave(2).semitonesFromRootHeight, 25);
          expect(Note.a.inOctave(2).semitonesFromRootHeight, 34);
          expect(Note.a.semitonesFromRootHeight, 58);
        },
      );
    });

    group('.difference()', () {
      test(
        'should return the difference in semitones with another Note',
        () {
          expect(Note.c.difference(Note.c), 0);
          expect(const Note(Notes.e, Accidental.sharp).difference(Note.f), 0);
          expect(Note.c.difference(Note.dFlat), 1);
          expect(Note.c.difference(Note.cSharp), 1);
          expect(Note.b.difference(Note.c.inOctave(5)), 1);
          expect(Note.f.difference(Note.g), 2);
          expect(Note.f.difference(Note.aFlat), 3);
          expect(Note.e.difference(Note.aFlat), 4);
          expect(Note.a.difference(Note.d.inOctave(5)), 5);
          expect(Note.d.difference(Note.aFlat), 6);
          expect(Note.eFlat.difference(Note.bFlat), 7);
          expect(Note.dSharp.difference(Note.aSharp), 7);
          expect(Note.d.difference(Note.aSharp), 8);
          expect(Note.cSharp.difference(Note.bFlat), 9);
          expect(Note.cSharp.difference(Note.b), 10);
          expect(Note.dFlat.difference(Note.b), 10);
          expect(Note.c.difference(Note.b), 11);
        },
      );
    });

    group('.exactFifthsDistance', () {
      test(
        'should return the fifths distance between this and other Note',
        () {
          expect(Note.c.exactFifthsDistance(Note.c), 0);
          expect(Note.aFlat.exactFifthsDistance(Note.cSharp), 11);
        },
      );
    });

    group('.exactInterval()', () {
      test('should return the Interval for a unison', () {
        expect(
          Note.c.exactInterval(Note.c),
          equals(const Interval.perfect(1, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.cSharp),
          equals(const Interval.perfect(1, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a second', () {
        expect(
          Note.c.exactInterval(const Note(Notes.d, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(2, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.dFlat),
          equals(const Interval.imperfect(2, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.d),
          equals(const Interval.imperfect(2, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(Note.dSharp),
          equals(
            const Interval.imperfect(2, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a third', () {
        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(3, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.eFlat),
          equals(const Interval.imperfect(3, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.e),
          equals(const Interval.imperfect(3, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(const Note(Notes.e, Accidental.sharp)),
          equals(
            const Interval.imperfect(3, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a fourth', () {
        expect(
          Note.c.exactInterval(const Note(Notes.f, Accidental.flat)),
          equals(const Interval.perfect(4, PerfectQuality.diminished)),
        );
        expect(
          Note.c.exactInterval(Note.f),
          equals(const Interval.perfect(4, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.fSharp),
          equals(const Interval.perfect(4, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a fifth', () {
        expect(
          Note.c.exactInterval(Note.gFlat),
          equals(const Interval.perfect(5, PerfectQuality.diminished)),
        );
        expect(
          Note.c.exactInterval(Note.g),
          equals(const Interval.perfect(5, PerfectQuality.perfect)),
        );
        expect(
          Note.c.exactInterval(Note.gSharp),
          equals(const Interval.perfect(5, PerfectQuality.augmented)),
        );
      });

      test('should return the Interval for a sixth', () {
        expect(
          Note.c.exactInterval(const Note(Notes.a, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(6, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.aFlat),
          equals(const Interval.imperfect(6, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.a),
          equals(const Interval.imperfect(6, ImperfectQuality.major)),
        );
        expect(
          Note.c.exactInterval(Note.aSharp),
          equals(
            const Interval.imperfect(6, ImperfectQuality.augmented),
          ),
        );
      });

      test('should return the Interval for a seventh', () {
        expect(
          Note.c.exactInterval(const Note(Notes.b, Accidental.doubleFlat)),
          equals(
            const Interval.imperfect(7, ImperfectQuality.diminished),
          ),
        );
        expect(
          Note.c.exactInterval(Note.bFlat),
          equals(const Interval.imperfect(7, ImperfectQuality.minor)),
        );
        expect(
          Note.c.exactInterval(Note.b),
          equals(const Interval.imperfect(7, ImperfectQuality.major)),
        );
        // TODO(albertms10): add test case for:
        //  `Note.c.exactInterval(const Note(Notes.b, Accidental.sharp))`.
      });
    });

    group('.equalTemperamentFrequency()', () {
      test('should return the hertzs of this Note from 440 Hz', () {
        expect(Note.c.equalTemperamentFrequency(), closeTo(261.63, 0.01));
        expect(Note.cSharp.equalTemperamentFrequency(), closeTo(277.18, 0.01));
        expect(Note.dFlat.equalTemperamentFrequency(), closeTo(277.18, 0.01));
        expect(Note.d.equalTemperamentFrequency(), closeTo(293.66, 0.01));
        expect(Note.dSharp.equalTemperamentFrequency(), closeTo(311.13, 0.01));
        expect(Note.eFlat.equalTemperamentFrequency(), closeTo(311.13, 0.01));
        expect(Note.e.equalTemperamentFrequency(), closeTo(329.63, 0.01));
        expect(Note.f.equalTemperamentFrequency(), closeTo(349.23, 0.01));
        expect(Note.fSharp.equalTemperamentFrequency(), closeTo(369.99, 0.01));
        expect(Note.gFlat.equalTemperamentFrequency(), closeTo(369.99, 0.01));
        expect(Note.g.equalTemperamentFrequency(), closeTo(392, 0.01));
        expect(Note.gSharp.equalTemperamentFrequency(), closeTo(415.3, 0.01));
        expect(Note.aFlat.equalTemperamentFrequency(), closeTo(415.3, 0.01));
        expect(Note.a.equalTemperamentFrequency(), 440);
        expect(Note.aSharp.equalTemperamentFrequency(), closeTo(466.16, 0.01));
        expect(Note.bFlat.equalTemperamentFrequency(), closeTo(466.16, 0.01));
        expect(Note.b.equalTemperamentFrequency(), closeTo(493.88, 0.01));
      });

      test('should return the hertzs of this Note from 438 Hz', () {
        expect(Note.c.equalTemperamentFrequency(438), closeTo(260.44, 0.01));
        expect(
          Note.cSharp.equalTemperamentFrequency(438),
          closeTo(275.92, 0.01),
        );
        expect(
          Note.dFlat.equalTemperamentFrequency(438),
          closeTo(275.92, 0.01),
        );
        expect(Note.d.equalTemperamentFrequency(438), closeTo(292.33, 0.01));
        expect(
          Note.dSharp.equalTemperamentFrequency(438),
          closeTo(309.71, 0.01),
        );
        expect(
          Note.eFlat.equalTemperamentFrequency(438),
          closeTo(309.71, 0.01),
        );
        expect(Note.e.equalTemperamentFrequency(438), closeTo(328.13, 0.01));
        expect(Note.f.equalTemperamentFrequency(438), closeTo(347.64, 0.01));
        expect(
          Note.fSharp.equalTemperamentFrequency(438),
          closeTo(368.31, 0.01),
        );
        expect(
          Note.gFlat.equalTemperamentFrequency(438),
          closeTo(368.31, 0.01),
        );
        expect(Note.g.equalTemperamentFrequency(438), closeTo(390.21, 0.01));
        expect(
          Note.gSharp.equalTemperamentFrequency(438),
          closeTo(413.42, 0.01),
        );
        expect(
          Note.aFlat.equalTemperamentFrequency(438),
          closeTo(413.42, 0.01),
        );
        expect(Note.a.equalTemperamentFrequency(438), 438);
        expect(
          Note.aSharp.equalTemperamentFrequency(438),
          closeTo(464.04, 0.01),
        );
        expect(
          Note.bFlat.equalTemperamentFrequency(438),
          closeTo(464.04, 0.01),
        );
        expect(Note.b.equalTemperamentFrequency(438), closeTo(491.64, 0.01));
      });
    });

    group('.isHumanAudible', () {
      test('should return whether this Note is human-audible', () {
        expect(Note.c.isHumanAudible, isTrue);
        expect(Note.a.inOctave(2).isHumanAudible, isTrue);
        expect(Note.d.inOctave(0).isHumanAudible, isFalse);
        expect(Note.d.inOctave(12).isHumanAudible, isFalse);
      });
    });

    group('.scientificName', () {
      test(
        'should return the scientific pitch notation name for this Note',
        () {
          expect(Note.gSharp.inOctave(-1).scientificName, 'G♯-1');
          expect(Note.d.inOctave(0).scientificName, 'D0');
          expect(Note.bFlat.inOctave(1).scientificName, 'B♭1');
          expect(Note.g.inOctave(2).scientificName, 'G2');
          expect(Note.a.inOctave(3).scientificName, 'A3');
          expect(Note.c.scientificName, 'C4');
          expect(Note.cSharp.scientificName, 'C♯4');
          expect(Note.a.scientificName, 'A4');
          expect(Note.fSharp.inOctave(5).scientificName, 'F♯5');
          expect(Note.e.inOctave(7).scientificName, 'E7');
        },
      );
    });

    group('.helmholtzName', () {
      test(
        'should return the Helmholtz pitch notation name for this Note',
        () {
          expect(Note.gSharp.inOctave(-1).helmholtzName, 'G♯͵͵͵');
          expect(Note.d.inOctave(0).helmholtzName, 'D͵͵');
          expect(Note.bFlat.inOctave(1).helmholtzName, 'B♭͵');
          expect(Note.g.inOctave(2).helmholtzName, 'G');
          expect(Note.a.inOctave(3).helmholtzName, 'a');
          expect(Note.c.helmholtzName, 'c′');
          expect(Note.cSharp.helmholtzName, 'c♯′');
          expect(Note.a.helmholtzName, 'a′');
          expect(Note.fSharp.inOctave(5).helmholtzName, 'f♯′′');
          expect(Note.e.inOctave(7).helmholtzName, 'e′′′′');
        },
      );
    });

    group('.toString()', () {
      test('should return the string representation of this Note', () {
        expect(Note.c.toString(), 'C');
        expect(Note.bFlat.toString(), 'B♭');
        expect(Note.fSharp.toString(), 'F♯');
        expect(const Note(Notes.a, Accidental.doubleSharp).toString(), 'A𝄪');
        expect(const Note(Notes.g, Accidental.doubleFlat).toString(), 'G𝄫');
      });
    });

    group('.hashCode', () {
      test('should ignore equal Note instances in a Set', () {
        final collection = {Note.c, Note.aFlat, Note.gSharp};
        collection.addAll(collection);
        expect(collection.toList(), const [Note.c, Note.aFlat, Note.gSharp]);
      });
    });

    group('.compareTo()', () {
      test('should correctly sort Note items in a collection', () {
        final orderedSet = SplayTreeSet<Note>.of(const [
          Note.aFlat,
          Note.c,
          Note.gSharp,
          Note(Notes.b, Accidental.sharp),
        ]);
        expect(orderedSet.toList(), const [
          Note.c,
          Note(Notes.b, Accidental.sharp),
          Note.gSharp,
          Note.aFlat,
        ]);
      });
    });
  });
}
