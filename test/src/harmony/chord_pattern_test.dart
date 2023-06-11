import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ChordPattern', () {
    group('.intervalSteps()', () {
      test('should create a new ChordPattern from interval steps', () {
        expect(
          ChordPattern.intervalSteps(const [Interval.m3, Interval.M3]),
          ChordPattern.minorTriad,
        );
        expect(
          ChordPattern.intervalSteps(
            const [Interval.M3, Interval.M3, Interval.m3],
          ),
          ChordPattern.augmentedTriad.add7(ImperfectQuality.major),
        );
        expect(
          ChordPattern.intervalSteps(
            const [Interval.M3, Interval.m3, Interval.P5],
          ),
          ChordPattern.majorTriad.add9(),
        );
      });
    });

    group('.fromQuality()', () {
      test('should create a new ChordPattern from the given Quality', () {
        expect(
          ChordPattern.fromQuality(ImperfectQuality.augmented),
          ChordPattern.augmentedTriad,
        );
        expect(
          ChordPattern.fromQuality(ImperfectQuality.major),
          ChordPattern.majorTriad,
        );
        expect(
          ChordPattern.fromQuality(ImperfectQuality.minor),
          ChordPattern.minorTriad,
        );
        expect(
          ChordPattern.fromQuality(ImperfectQuality.diminished),
          ChordPattern.diminishedTriad,
        );
      });
    });

    group('.on()', () {
      test('should return the Chord from this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.on(Note.e),
          Chord([Note.e, Note.g.sharp, Note.b]),
        );
        expect(
          ChordPattern.minorTriad.add7().on(Note.f),
          Chord([Note.f, Note.a.flat, Note.c, Note.e.flat]),
        );
        expect(
          ChordPattern.majorTriad.add7().add9().on(Note.d),
          Chord([Note.d, Note.f.sharp, Note.a, Note.c, Note.e]),
        );
        expect(
          ChordPattern.diminishedTriad
              .add7(ImperfectQuality.diminished)
              .on(Note.b.flat.inOctave(4)),
          Chord([
            Note.b.flat.inOctave(4),
            Note.d.flat.inOctave(5),
            Note.f.flat.inOctave(5),
            Note.a.flat.flat.inOctave(5),
          ]),
        );
      });
    });

    group('.rootTriad', () {
      test('should return the root triad of this ChordPattern', () {
        expect(
          const ChordPattern([Interval.M3, Interval.A5, Interval.M7]).rootTriad,
          ChordPattern.augmentedTriad,
        );
        expect(ChordPattern.majorTriad.rootTriad, ChordPattern.majorTriad);
        expect(
          ChordPattern.minorTriad.add7().add9().rootTriad,
          ChordPattern.minorTriad,
        );
        expect(
          const ChordPattern([Interval.m3, Interval.d5, Interval.d7]).rootTriad,
          ChordPattern.diminishedTriad,
        );
      });
    });

    group('.isAugmented', () {
      test('should return whether this ChordPattern is augmented', () {
        expect(ChordPattern.augmentedTriad.isAugmented, isTrue);
        expect(ChordPattern.majorTriad.isAugmented, isFalse);
        expect(ChordPattern.minorTriad.isAugmented, isFalse);
        expect(ChordPattern.diminishedTriad.isAugmented, isFalse);

        expect(ChordPattern.augmentedTriad.add7().add9().isAugmented, isTrue);
      });
    });

    group('.isMajor', () {
      test('should return whether this ChordPattern is major', () {
        expect(ChordPattern.augmentedTriad.isMajor, isFalse);
        expect(ChordPattern.majorTriad.isMajor, isTrue);
        expect(ChordPattern.minorTriad.isMajor, isFalse);
        expect(ChordPattern.diminishedTriad.isMajor, isFalse);

        expect(ChordPattern.majorTriad.add7().add9().isMajor, isTrue);
      });
    });

    group('.isMinor', () {
      test('should return whether this ChordPattern is minor', () {
        expect(ChordPattern.augmentedTriad.isMinor, isFalse);
        expect(ChordPattern.majorTriad.isMinor, isFalse);
        expect(ChordPattern.minorTriad.isMinor, isTrue);
        expect(ChordPattern.diminishedTriad.isMinor, isFalse);

        expect(ChordPattern.minorTriad.add7().add9().isMinor, isTrue);
      });
    });

    group('.isDiminished', () {
      test('should return whether this ChordPattern is diminished', () {
        expect(ChordPattern.augmentedTriad.isDiminished, isFalse);
        expect(ChordPattern.majorTriad.isDiminished, isFalse);
        expect(ChordPattern.minorTriad.isDiminished, isFalse);
        expect(ChordPattern.diminishedTriad.isDiminished, isTrue);

        expect(ChordPattern.diminishedTriad.add7().add9().isDiminished, isTrue);
      });
    });

    group('.modifiers', () {
      test(
        'should return the list of modifier Intervals from the root note',
        () {
          expect(ChordPattern.majorTriad.modifiers, const <Interval>[]);
          expect(
            ChordPattern.minorTriad.add6().add9().modifiers,
            const [Interval.M6, Interval.M9],
          );
          expect(
            ChordPattern.augmentedTriad.sus2().add7().add13().modifiers,
            const [Interval.m7, Interval.M13],
          );
        },
      );
    });

    group('.augmented', () {
      test('should return a new ChordPattern with an augmented root triad', () {
        expect(
          ChordPattern.minorTriad.augmented,
          ChordPattern.augmentedTriad,
        );
        expect(
          ChordPattern.majorTriad.add7().add9().augmented,
          const ChordPattern(
            [Interval.M3, Interval.A5, Interval.m7, Interval.M9],
          ),
        );
      });
    });

    group('.major', () {
      test('should return a new ChordPattern with a major root triad', () {
        expect(ChordPattern.minorTriad.major, ChordPattern.majorTriad);
        expect(
          ChordPattern.minorTriad.add7().add9().major,
          const ChordPattern(
            [Interval.M3, Interval.P5, Interval.m7, Interval.M9],
          ),
        );
      });
    });

    group('.minor', () {
      test('should return a new ChordPattern with a minor root triad', () {
        expect(ChordPattern.augmentedTriad.minor, ChordPattern.minorTriad);
        expect(
          ChordPattern.majorTriad.add7().add9().minor,
          const ChordPattern(
            [Interval.m3, Interval.P5, Interval.m7, Interval.M9],
          ),
        );
      });
    });

    group('.diminished', () {
      test('should return a new ChordPattern with a diminished root triad', () {
        expect(
          ChordPattern.majorTriad.diminished,
          ChordPattern.diminishedTriad,
        );
        expect(
          ChordPattern.augmentedTriad.add7().add9().diminished,
          const ChordPattern(
            [Interval.m3, Interval.d5, Interval.m7, Interval.M9],
          ),
        );
      });
    });

    group('.sus2()', () {
      test('should turn this ChordPattern into a suspended 2nd chord', () {
        expect(
          ChordPattern.majorTriad.sus2(),
          const ChordPattern([Interval.M2, Interval.P5]),
        );
        expect(
          ChordPattern.minorTriad.sus4().sus2(),
          const ChordPattern([Interval.M2, Interval.P5]),
        );
        expect(
          ChordPattern.majorTriad.sus2().sus2(),
          const ChordPattern([Interval.M2, Interval.P5]),
        );
        expect(
          ChordPattern.minorTriad.add7().sus2(),
          const ChordPattern([Interval.M2, Interval.P5, Interval.m7]),
        );
      });
    });

    group('.sus4()', () {
      test('should turn this ChordPattern into a suspended 4th chord', () {
        expect(
          ChordPattern.majorTriad.sus4(),
          const ChordPattern([Interval.P4, Interval.P5]),
        );
        expect(
          ChordPattern.minorTriad.sus2().sus4(),
          const ChordPattern([Interval.P4, Interval.P5]),
        );
        expect(
          ChordPattern.majorTriad.sus4().sus4(),
          const ChordPattern([Interval.P4, Interval.P5]),
        );
        expect(
          ChordPattern.minorTriad.add7().sus4(),
          const ChordPattern([Interval.P4, Interval.P5, Interval.m7]),
        );
      });
    });

    group('.add6()', () {
      test('should add a 6th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add6(),
          const ChordPattern([Interval.M3, Interval.P5, Interval.M6]),
        );
        expect(
          ChordPattern.minorTriad.sus2().add6(),
          const ChordPattern([Interval.M2, Interval.P5, Interval.M6]),
        );
        expect(
          ChordPattern.majorTriad.sus2().add6(ImperfectQuality.minor),
          const ChordPattern([Interval.M2, Interval.P5, Interval.m6]),
        );
        expect(
          ChordPattern.minorTriad.add6(ImperfectQuality.minor).add9(),
          const ChordPattern(
            [Interval.m3, Interval.P5, Interval.m6, Interval.M9],
          ),
        );
      });
    });

    group('.add7()', () {
      test('should add a 7th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add7(),
          const ChordPattern([Interval.M3, Interval.P5, Interval.m7]),
        );
        expect(
          ChordPattern.minorTriad.sus2().add7(),
          const ChordPattern([Interval.M2, Interval.P5, Interval.m7]),
        );
        expect(
          ChordPattern.majorTriad.sus2().add7(ImperfectQuality.major),
          const ChordPattern([Interval.M2, Interval.P5, Interval.M7]),
        );
        expect(
          ChordPattern.minorTriad.add7(ImperfectQuality.major),
          const ChordPattern([Interval.m3, Interval.P5, Interval.M7]),
        );
      });
    });

    group('.add9()', () {
      test('should add a 9th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add9(),
          const ChordPattern([Interval.M3, Interval.P5, Interval.M9]),
        );
        expect(
          ChordPattern.minorTriad.sus4().add9(),
          const ChordPattern([Interval.P4, Interval.P5, Interval.M9]),
        );
        expect(
          ChordPattern.majorTriad.sus2().add9(ImperfectQuality.minor),
          const ChordPattern([Interval.M2, Interval.P5, Interval.m9]),
        );
        expect(
          ChordPattern.minorTriad.add9(ImperfectQuality.minor),
          const ChordPattern([Interval.m3, Interval.P5, Interval.m9]),
        );
      });
    });

    group('.add11()', () {
      test('should add an 11th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add11(),
          const ChordPattern([Interval.M3, Interval.P5, Interval.P11]),
        );
        expect(
          ChordPattern.minorTriad.add7().add9().add11(),
          const ChordPattern([
            Interval.m3,
            Interval.P5,
            Interval.m7,
            Interval.M9,
            Interval.P11,
          ]),
        );
        expect(
          ChordPattern.majorTriad
              .sus2()
              .add9(ImperfectQuality.minor)
              .add11(PerfectQuality.diminished),
          const ChordPattern(
            [Interval.M2, Interval.P5, Interval.m9, Interval.d11],
          ),
        );
        expect(
          ChordPattern.minorTriad.add11(PerfectQuality.augmented),
          const ChordPattern([Interval.m3, Interval.P5, Interval.A11]),
        );
      });
    });

    group('.add13()', () {
      test('should add an 13th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add13(),
          const ChordPattern([Interval.M3, Interval.P5, Interval.M13]),
        );
        expect(
          ChordPattern.minorTriad.add7().add9().add11().add13(),
          const ChordPattern([
            Interval.m3,
            Interval.P5,
            Interval.m7,
            Interval.M9,
            Interval.P11,
            Interval.M13,
          ]),
        );
        expect(
          ChordPattern.majorTriad
              .add9(ImperfectQuality.minor)
              .add11(PerfectQuality.augmented)
              .sus2()
              .add13(ImperfectQuality.minor),
          const ChordPattern([
            Interval.M2,
            Interval.P5,
            Interval.m9,
            Interval.A11,
            Interval.m13,
          ]),
        );
        expect(
          ChordPattern.minorTriad.add13(ImperfectQuality.minor),
          const ChordPattern([Interval.m3, Interval.P5, Interval.m13]),
        );
      });
    });

    group('.add()', () {
      test('should add an Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add(Interval.M7),
          const ChordPattern([Interval.M3, Interval.P5, Interval.M7]),
        );
      });

      test('should ignore any previous Interval size in this ChordPattern', () {
        expect(
          const ChordPattern([Interval.m3, Interval.P5, Interval.M7])
              .add(Interval.M7),
          const ChordPattern([Interval.m3, Interval.P5, Interval.M7]),
        );
        expect(
          const ChordPattern([Interval.m3, Interval.P5, Interval.M7])
              .add(Interval.m7),
          const ChordPattern([Interval.m3, Interval.P5, Interval.m7]),
        );
      });
    });

    group('.toString()', () {
      test(
        'should return the string representation of this ChordPattern',
        () {
          expect(ChordPattern.augmentedTriad.toString(), 'aug. (M3 A5)');
          expect(ChordPattern.majorTriad.toString(), 'maj. (M3 P5)');
          expect(ChordPattern.minorTriad.toString(), 'min. (m3 P5)');
          expect(ChordPattern.diminishedTriad.toString(), 'dim. (m3 d5)');

          expect(
            ChordPattern.augmentedTriad.add7().toString(),
            'aug. (M3 A5 m7)',
          );
          expect(ChordPattern.majorTriad.add7().toString(), 'maj. (M3 P5 m7)');
          expect(ChordPattern.minorTriad.add7().toString(), 'min. (m3 P5 m7)');
          expect(
            ChordPattern.diminishedTriad.add7().toString(),
            'dim. (m3 d5 m7)',
          );
        },
      );
    });

    group('.hashCode', () {
      test('should ignore equal ChordPattern instances in a Set', () {
        final collection = {
          ChordPattern.augmentedTriad,
          ChordPattern.majorTriad,
          ChordPattern.minorTriad,
          ChordPattern.diminishedTriad,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          ChordPattern.augmentedTriad,
          ChordPattern.majorTriad,
          ChordPattern.minorTriad,
          ChordPattern.diminishedTriad,
        ]);
      });
    });
  });
}
