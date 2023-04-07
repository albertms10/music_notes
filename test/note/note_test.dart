import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('Note', () {
    group('.semitones', () {
      test('should return the semitones value of this Note', () {
        expect(const Note(Notes.b, Accidental.sharp).semitones, 1);
        expect(const Note(Notes.c).semitones, 1);
        expect(const Note(Notes.c, Accidental.sharp).semitones, 2);
        expect(const Note(Notes.d, Accidental.flat).semitones, 2);
        expect(const Note(Notes.d).semitones, 3);
        expect(const Note(Notes.d, Accidental.sharp).semitones, 4);
        expect(const Note(Notes.e, Accidental.flat).semitones, 4);
        expect(const Note(Notes.e).semitones, 5);
        expect(const Note(Notes.f).semitones, 6);
        expect(const Note(Notes.f, Accidental.sharp).semitones, 7);
        expect(const Note(Notes.g, Accidental.flat).semitones, 7);
        expect(const Note(Notes.g).semitones, 8);
        expect(const Note(Notes.g, Accidental.sharp).semitones, 9);
        expect(const Note(Notes.a, Accidental.flat).semitones, 9);
        expect(const Note(Notes.a).semitones, 10);
        expect(const Note(Notes.a, Accidental.sharp).semitones, 11);
        expect(const Note(Notes.b, Accidental.flat).semitones, 11);
        expect(const Note(Notes.b).semitones, 12);
        expect(const Note(Notes.c, Accidental.flat).semitones, 12);
      });
    });

    group('.difference()', () {
      test(
        'should return the difference in semitones with another Note',
        () {
          expect(const Note(Notes.c).difference(const Note(Notes.c)), 0);
          expect(
            const Note(Notes.e, Accidental.sharp)
                .difference(const Note(Notes.f)),
            0,
          );
          expect(
            const Note(Notes.d)
                .difference(const Note(Notes.a, Accidental.flat)),
            6,
          );
        },
      );
    });
  });
}
