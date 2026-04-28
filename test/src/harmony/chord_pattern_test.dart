import 'dart:collection' show UnmodifiableListView;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('ChordPattern', () {
    group('.intervals', () {
      test('returns an unmodifiable collection', () {
        expect(
          ChordPattern.majorTriad.intervals,
          isA<UnmodifiableListView<Interval>>(),
        );
      });
    });

    group('.fromIntervalSteps()', () {
      test('creates a new ChordPattern from interval steps', () {
        expect(
          ChordPattern.fromIntervalSteps(const [.m3, .M3]),
          ChordPattern.minorTriad,
        );
        expect(
          ChordPattern.fromIntervalSteps(const [.M3, .M3, .m3]),
          ChordPattern.augmentedTriad.add7(ImperfectQuality.major),
        );
        expect(
          ChordPattern.fromIntervalSteps(const [.M3, .m3, .P5]),
          ChordPattern.majorTriad.add9(),
        );
      });
    });

    group('.fromQuality()', () {
      test('creates a new ChordPattern from the given Quality', () {
        expect(
          ChordPattern.fromQuality(.augmented),
          ChordPattern.augmentedTriad,
        );
        expect(ChordPattern.fromQuality(.major), ChordPattern.majorTriad);
        expect(ChordPattern.fromQuality(.minor), ChordPattern.minorTriad);
        expect(
          ChordPattern.fromQuality(.diminished),
          ChordPattern.diminishedTriad,
        );
      });
    });

    group('.on()', () {
      test('returns the Chord built on Scalable', () {
        expect(
          ChordPattern.majorTriad.on(Note.e),
          Chord<Note>([.e, .g.sharp, .b]),
        );
        expect(
          ChordPattern.minorTriad.add7().on(Note.f),
          Chord<Note>([.f, .a.flat, .c, .e.flat]),
        );
        expect(
          ChordPattern.majorTriad.add7().add9().on(Note.d),
          Chord<Note>([.d, .f.sharp, .a, .c, .e]),
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

    group('.under()', () {
      test('returns the Chord built under Scalable', () {
        expect(
          ChordPattern.majorTriad.under(Note.e),
          const Chord<Note>([.a, .c, .e]),
        );
        expect(
          ChordPattern.minorTriad.add7().under(Note.f),
          Chord<Note>([.g, .b.flat, .d, .f]),
        );
        expect(
          ChordPattern.majorTriad.add7().add9().under(Note.d),
          Chord<Note>([.c, .e, .g, .b.flat, .d]),
        );
        expect(
          ChordPattern.diminishedTriad
              .add7(.diminished)
              .under(Note.b.flat.inOctave(4)),
          Chord([
            Note.c.sharp.inOctave(4),
            Note.e.inOctave(4),
            Note.g.inOctave(4),
            Note.b.flat.inOctave(4),
          ]),
        );
      });
    });

    group('.rootTriad', () {
      test('returns the root triad of this ChordPattern', () {
        expect(
          const ChordPattern([.M3, .A5, .M7]).rootTriad,
          ChordPattern.augmentedTriad,
        );
        expect(ChordPattern.majorTriad.rootTriad, ChordPattern.majorTriad);
        expect(
          ChordPattern.minorTriad.add7().add9().rootTriad,
          ChordPattern.minorTriad,
        );
        expect(
          const ChordPattern([.m3, .d5, .d7]).rootTriad,
          ChordPattern.diminishedTriad,
        );
      });
    });

    group('.isAugmented', () {
      test('returns whether this ChordPattern is augmented', () {
        expect(ChordPattern.augmentedTriad.isAugmented, isTrue);
        expect(ChordPattern.majorTriad.isAugmented, isFalse);
        expect(ChordPattern.minorTriad.isAugmented, isFalse);
        expect(ChordPattern.diminishedTriad.isAugmented, isFalse);

        expect(ChordPattern.augmentedTriad.add7().add9().isAugmented, isTrue);
      });
    });

    group('.isMajor', () {
      test('returns whether this ChordPattern is major', () {
        expect(ChordPattern.augmentedTriad.isMajor, isFalse);
        expect(ChordPattern.majorTriad.isMajor, isTrue);
        expect(ChordPattern.minorTriad.isMajor, isFalse);
        expect(ChordPattern.diminishedTriad.isMajor, isFalse);

        expect(ChordPattern.majorTriad.add7().add9().isMajor, isTrue);
      });
    });

    group('.isMinor', () {
      test('returns whether this ChordPattern is minor', () {
        expect(ChordPattern.augmentedTriad.isMinor, isFalse);
        expect(ChordPattern.majorTriad.isMinor, isFalse);
        expect(ChordPattern.minorTriad.isMinor, isTrue);
        expect(ChordPattern.diminishedTriad.isMinor, isFalse);

        expect(ChordPattern.minorTriad.add7().add9().isMinor, isTrue);
      });
    });

    group('.isDiminished', () {
      test('returns whether this ChordPattern is diminished', () {
        expect(ChordPattern.augmentedTriad.isDiminished, isFalse);
        expect(ChordPattern.majorTriad.isDiminished, isFalse);
        expect(ChordPattern.minorTriad.isDiminished, isFalse);
        expect(ChordPattern.diminishedTriad.isDiminished, isTrue);

        expect(ChordPattern.diminishedTriad.add7().add9().isDiminished, isTrue);
      });
    });

    group('.modifiers', () {
      test('returns the list of modifier Intervals from the root note', () {
        expect(ChordPattern.majorTriad.modifiers, const <Interval>[]);
        expect(
          ChordPattern.minorTriad.add6().add9().modifiers,
          const <Interval>[.M6, .M9],
        );
        expect(
          ChordPattern.augmentedTriad.sus2().add7().add13().modifiers,
          const <Interval>[.m7, .M13],
        );
      });
    });

    group('.augmented', () {
      test('returns a new ChordPattern with an augmented root triad', () {
        expect(ChordPattern.minorTriad.augmented, ChordPattern.augmentedTriad);
        expect(
          ChordPattern.majorTriad.add7().add9().augmented,
          const ChordPattern([.M3, .A5, .m7, .M9]),
        );
      });
    });

    group('.major', () {
      test('returns a new ChordPattern with a major root triad', () {
        expect(ChordPattern.minorTriad.major, ChordPattern.majorTriad);
        expect(
          ChordPattern.minorTriad.add7().add9().major,
          const ChordPattern([.M3, .P5, .m7, .M9]),
        );
      });
    });

    group('.minor', () {
      test('returns a new ChordPattern with a minor root triad', () {
        expect(ChordPattern.augmentedTriad.minor, ChordPattern.minorTriad);
        expect(
          ChordPattern.majorTriad.add7().add9().minor,
          const ChordPattern([.m3, .P5, .m7, .M9]),
        );
      });
    });

    group('.diminished', () {
      test('returns a new ChordPattern with a diminished root triad', () {
        expect(
          ChordPattern.majorTriad.diminished,
          ChordPattern.diminishedTriad,
        );
        expect(
          ChordPattern.augmentedTriad.add7().add9().diminished,
          const ChordPattern([.m3, .d5, .m7, .M9]),
        );
      });
    });

    group('.sus2()', () {
      test('turns this ChordPattern into a suspended 2nd chord', () {
        expect(ChordPattern.majorTriad.sus2(), const ChordPattern([.M2, .P5]));
        expect(
          ChordPattern.minorTriad.sus4().sus2(),
          const ChordPattern([.M2, .P5]),
        );
        expect(
          ChordPattern.majorTriad.sus2().sus2(),
          const ChordPattern([.M2, .P5]),
        );
        expect(
          ChordPattern.minorTriad.add7().sus2(),
          const ChordPattern([.M2, .P5, .m7]),
        );
      });
    });

    group('.sus4()', () {
      test('turns this ChordPattern into a suspended 4th chord', () {
        expect(ChordPattern.majorTriad.sus4(), const ChordPattern([.P4, .P5]));
        expect(
          ChordPattern.minorTriad.sus2().sus4(),
          const ChordPattern([.P4, .P5]),
        );
        expect(
          ChordPattern.majorTriad.sus4().sus4(),
          const ChordPattern([.P4, .P5]),
        );
        expect(
          ChordPattern.minorTriad.add7().sus4(),
          const ChordPattern([.P4, .P5, .m7]),
        );
      });
    });

    group('.add6()', () {
      test('adds a 6th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add6(),
          const ChordPattern([.M3, .P5, .M6]),
        );
        expect(
          ChordPattern.minorTriad.sus2().add6(),
          const ChordPattern([.M2, .P5, .M6]),
        );
        expect(
          ChordPattern.majorTriad.sus2().add6(.minor),
          const ChordPattern([.M2, .P5, .m6]),
        );
        expect(
          ChordPattern.minorTriad.add6(.minor).add9(),
          const ChordPattern([.m3, .P5, .m6, .M9]),
        );
      });
    });

    group('.add7()', () {
      test('adds a 7th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add7(),
          const ChordPattern([.M3, .P5, .m7]),
        );
        expect(
          ChordPattern.minorTriad.sus2().add7(),
          const ChordPattern([.M2, .P5, .m7]),
        );
        expect(
          ChordPattern.majorTriad.sus2().add7(.major),
          const ChordPattern([.M2, .P5, .M7]),
        );
        expect(
          ChordPattern.minorTriad.add7(.major),
          const ChordPattern([.m3, .P5, .M7]),
        );
      });
    });

    group('.add9()', () {
      test('adds a 9th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add9(),
          const ChordPattern([.M3, .P5, .M9]),
        );
        expect(
          ChordPattern.minorTriad.sus4().add9(),
          const ChordPattern([.P4, .P5, .M9]),
        );
        expect(
          ChordPattern.majorTriad.sus2().add9(.minor),
          const ChordPattern([.M2, .P5, .m9]),
        );
        expect(
          ChordPattern.minorTriad.add9(.minor),
          const ChordPattern([.m3, .P5, .m9]),
        );
      });
    });

    group('.add11()', () {
      test('adds an 11th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add11(),
          const ChordPattern([.M3, .P5, .P11]),
        );
        expect(
          ChordPattern.minorTriad.add7().add9().add11(),
          const ChordPattern([.m3, .P5, .m7, .M9, .P11]),
        );
        expect(
          ChordPattern.majorTriad.sus2().add9(.minor).add11(.diminished),
          const ChordPattern([.M2, .P5, .m9, .d11]),
        );
        expect(
          ChordPattern.minorTriad.add11(.augmented),
          const ChordPattern([.m3, .P5, .A11]),
        );
      });
    });

    group('.add13()', () {
      test('adds an 13th Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add13(),
          const ChordPattern([.M3, .P5, .M13]),
        );
        expect(
          ChordPattern.minorTriad.add7().add9().add11().add13(),
          const ChordPattern([.m3, .P5, .m7, .M9, .P11, .M13]),
        );
        expect(
          ChordPattern.majorTriad
              .add9(.minor)
              .add11(.augmented)
              .sus2()
              .add13(.minor),
          const ChordPattern([.M2, .P5, .m9, .A11, .m13]),
        );
        expect(
          ChordPattern.minorTriad.add13(.minor),
          const ChordPattern([.m3, .P5, .m13]),
        );
      });
    });

    group('.add()', () {
      test('adds an Interval to this ChordPattern', () {
        expect(
          ChordPattern.majorTriad.add(.M2, replaceSizes: const {.third}),
          const ChordPattern([.M2, .P5]),
        );
        expect(
          ChordPattern.majorTriad.add(.M7),
          const ChordPattern([.M3, .P5, .M7]),
        );
      });

      test('ignores any previous Interval size in this ChordPattern', () {
        expect(
          const ChordPattern([.m3, .P5, .M7]).add(.M7),
          const ChordPattern([.m3, .P5, .M7]),
        );
        expect(
          const ChordPattern([.m3, .P5, .M7]).add(.m7),
          const ChordPattern([.m3, .P5, .m7]),
        );
      });
    });

    group('.toString()', () {
      test(
        'returns the verbose string representation of this ChordPattern',
        () {
          expect(
            ChordPattern.majorTriad.toString(),
            '''
ChordPattern(intervals: [
\tInterval(size: 3, quality: ImperfectQuality(semitones: 1)),
\tInterval(size: 5, quality: PerfectQuality(semitones: 0))
])''',
          );
          expect(
            ChordPattern.minorTriad.add7(.major).toString(),
            '''
ChordPattern(intervals: [
\tInterval(size: 3, quality: ImperfectQuality(semitones: 0)),
\tInterval(size: 5, quality: PerfectQuality(semitones: 0)),
\tInterval(size: 7, quality: ImperfectQuality(semitones: 1))
])''',
          );
        },
      );
    });

    group('.hashCode', () {
      test('ignores equal ChordPattern instances in a Set', () {
        final collection = <ChordPattern>{
          .augmentedTriad,
          .majorTriad,
          .minorTriad,
          .diminishedTriad,
        };
        collection.addAll(collection);
        expect(collection.toList(), <ChordPattern>[
          .augmentedTriad,
          .majorTriad,
          .minorTriad,
          .diminishedTriad,
        ]);
      });
    });
  });

  group('ChordPatternNotation', () {
    group('.parse()', () {
      test('parses source as a ChordPattern', () {
        expect(ChordPattern.parse('+'), ChordPattern.augmentedTriad);
        expect(ChordPattern.parse(''), ChordPattern.majorTriad);
        expect(ChordPattern.parse('-'), ChordPattern.minorTriad);
        expect(ChordPattern.parse('dim'), ChordPattern.diminishedTriad);

        expect(ChordPattern.parse('7'), ChordPattern.majorTriad.add7());
        expect(
          ChordPattern.parse('maj7'),
          ChordPattern.majorTriad.add7(.major),
        );
        expect(ChordPattern.parse('-7'), ChordPattern.minorTriad.add7());
        expect(
          ChordPattern.parse('- maj7'),
          ChordPattern.minorTriad.add7(.major),
        );
        expect(
          ChordPattern.parse('-maj7'),
          ChordPattern.minorTriad.add7(.major),
        );
        expect(ChordPattern.parse('ø'), ChordPattern.diminishedTriad.add7());
        expect(ChordPattern.parse('sus2'), const ChordPattern([.M2, .P5]));
        expect(ChordPattern.parse('sus4'), const ChordPattern([.P4, .P5]));
        expect(ChordPattern.parse(' SuS2 '), const ChordPattern([.M2, .P5]));
        expect(ChordPattern.parse(' sus4 '), const ChordPattern([.P4, .P5]));
      });
    });

    group('.format()', () {
      test('returns the string representation of this ChordPattern', () {
        expect(ChordPattern.augmentedTriad.format(), '+');
        expect(ChordPattern.majorTriad.format(), '');
        expect(ChordPattern.minorTriad.format(), '-');
        expect(ChordPattern.diminishedTriad.format(), 'dim');

        expect(ChordPattern.majorTriad.add7().format(), '7');
        expect(ChordPattern.majorTriad.add7(.major).format(), 'maj7');
        expect(ChordPattern.minorTriad.add7().format(), '-7');
        expect(ChordPattern.minorTriad.add9().format(), '-9');
        expect(ChordPattern.minorTriad.add11().format(), '-11');
        expect(ChordPattern.minorTriad.add13().format(), '-13');
        expect(ChordPattern.minorTriad.add7(.major).format(), '-maj7');
        expect(ChordPattern.diminishedTriad.add7().format(), 'ø');
        expect(
          ChordPattern.diminishedTriad.add7(.diminished).format(),
          'º',
        );

        expect(ChordPattern.majorTriad.sus2().format(), 'sus2');
        expect(ChordPattern.majorTriad.sus4().format(), 'sus4');
        expect(ChordPattern.minorTriad.sus2().add7().format(), 'sus27');
        expect(ChordPattern.minorTriad.sus4().add7().format(), 'sus47');
        expect(ChordPattern.majorTriad.add6().format(), '6');
        expect(ChordPattern.minorTriad.add6().format(), '-6');
        expect(ChordPattern.majorTriad.add7().add9().format(), '7 9');
        expect(ChordPattern.minorTriad.add7().add9().format(), '-7 9');
        expect(ChordPattern.minorTriad.add7().add9().format(), '-7 9');
        expect(
          ChordPattern.majorTriad.add7(.major).add9().format(),
          'maj7 9',
        );

        expect(ChordPattern.majorTriad.add9(.diminished).format(), '𝄫9');
        expect(ChordPattern.majorTriad.add9(.minor).format(), '♭9');
        expect(ChordPattern.majorTriad.add9().format(), '9');
        expect(ChordPattern.majorTriad.add9(.augmented).format(), '♯9');

        expect(ChordPattern.majorTriad.add11(.diminished).format(), '♭11');
        expect(ChordPattern.majorTriad.add11().format(), '11');
        expect(ChordPattern.majorTriad.add11(.augmented).format(), '♯11');
        expect(
          ChordPattern.majorTriad.add11(.doublyAugmented).format(),
          '𝄪11',
        );

        expect(ChordPattern.majorTriad.add13(.diminished).format(), '𝄫13');
        expect(ChordPattern.majorTriad.add13(.minor).format(), '♭13');
        expect(ChordPattern.majorTriad.add13().format(), '13');
        expect(ChordPattern.majorTriad.add13(.augmented).format(), '♯13');
      });
    });
  });
}
