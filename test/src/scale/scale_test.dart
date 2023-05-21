import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Scale', () {
    group('.pattern', () {
      test('should return the ScalePattern of this Scale', () {
        expect(ScalePattern.aeolian.from(Note.c).pattern, ScalePattern.aeolian);
        expect(
          ScalePattern.harmonicMinor.from(Note.f.sharp).pattern,
          ScalePattern.harmonicMinor,
        );
        expect(
          ScalePattern.melodicMinor.from(Note.a.flat).pattern,
          ScalePattern.melodicMinor,
        );
      });
    });

    group('.reversed', () {
      test('should return this Scale reversed', () {
        expect(
          Note.a.major.scale.reversed,
          Scale([
            Note.a,
            Note.g.sharp,
            Note.f.sharp,
            Note.e,
            Note.d,
            Note.c.sharp,
            Note.b,
            Note.a,
          ]),
        );
        expect(
          ScalePattern.naturalMinor.from(Note.g.inOctave(5)).reversed,
          Scale([
            Note.g.inOctave(6),
            Note.f.inOctave(6),
            Note.e.flat.inOctave(6),
            Note.d.inOctave(6),
            Note.c.inOctave(6),
            Note.b.flat.inOctave(5),
            Note.a.inOctave(5),
            Note.g.inOctave(5),
          ]),
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal Scale instances in a Set', () {
        final collection = {
          Note.a.major.scale,
          Note.c.sharp.minor.scale,
          Note.d.flat.major.scale,
          Note.g.minor.scale,
        };
        collection.addAll(collection);
        expect(collection.toList(), [
          Note.a.major.scale,
          Note.c.sharp.minor.scale,
          Note.d.flat.major.scale,
          Note.g.minor.scale,
        ]);
      });
    });
  });
}
