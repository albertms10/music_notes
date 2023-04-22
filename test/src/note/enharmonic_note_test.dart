import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicNote', () {
    group('constructor', () {
      test(
        'should throw an assertion error when arguments are incorrect',
        () {
          expect(() => EnharmonicNote(-2), throwsA(isA<AssertionError>()));
          expect(() => EnharmonicNote(13), throwsA(isA<AssertionError>()));
        },
      );
    });

    group('.items', () {
      test('should return the correct Notes for this EnharmonicNote', () {
        expect(EnharmonicNote.c.items, {
          const Note(Notes.b, Accidental.sharp),
          Note.c,
          const Note(Notes.d, Accidental.doubleFlat),
        });
        expect(EnharmonicNote.cSharp.items, {Note.cSharp, Note.dFlat});
        expect(EnharmonicNote.d.items, {
          const Note(Notes.c, Accidental.doubleSharp),
          Note.d,
          const Note(Notes.e, Accidental.doubleFlat),
        });
        expect(EnharmonicNote.dSharp.items, {Note.dSharp, Note.eFlat});
        expect(EnharmonicNote.e.items, {
          const Note(Notes.d, Accidental.doubleSharp),
          Note.e,
          const Note(Notes.f, Accidental.flat),
        });
        expect(EnharmonicNote.f.items, {
          const Note(Notes.e, Accidental.sharp),
          Note.f,
          const Note(Notes.g, Accidental.doubleFlat),
        });
        expect(EnharmonicNote.fSharp.items, {Note.fSharp, Note.gFlat});
        expect(EnharmonicNote.g.items, {
          const Note(Notes.f, Accidental.doubleSharp),
          Note.g,
          const Note(Notes.a, Accidental.doubleFlat),
        });
        expect(EnharmonicNote.gSharp.items, {Note.gSharp, Note.aFlat});
        expect(EnharmonicNote.a.items, {
          const Note(Notes.g, Accidental.doubleSharp),
          Note.a,
          const Note(Notes.b, Accidental.doubleFlat),
        });
        expect(EnharmonicNote.aSharp.items, {Note.aSharp, Note.bFlat});
        expect(EnharmonicNote.b.items, {
          const Note(Notes.a, Accidental.doubleSharp),
          Note.b,
          const Note(Notes.c, Accidental.flat),
        });
      });
    });

    group('.toNote()', () {
      test(
        'should return the Note that matches with the accidental',
        () {
          expect(EnharmonicNote.c.toNote(), Note.c);
          expect(
            EnharmonicNote.c.toNote(Accidental.sharp),
            const Note(Notes.b, Accidental.sharp),
          );
          expect(
            EnharmonicNote.c.toNote(Accidental.doubleFlat),
            const Note(Notes.d, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.cSharp.toNote(), Note.cSharp);
          expect(EnharmonicNote.cSharp.toNote(Accidental.flat), Note.dFlat);

          expect(EnharmonicNote.d.toNote(), Note.d);
          expect(
            EnharmonicNote.d.toNote(Accidental.doubleSharp),
            const Note(Notes.c, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.d.toNote(Accidental.doubleFlat),
            const Note(Notes.e, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.dSharp.toNote(), Note.dSharp);
          expect(EnharmonicNote.dSharp.toNote(Accidental.flat), Note.eFlat);

          expect(EnharmonicNote.e.toNote(), Note.e);
          expect(
            EnharmonicNote.e.toNote(Accidental.doubleSharp),
            const Note(Notes.d, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.e.toNote(Accidental.flat),
            const Note(Notes.f, Accidental.flat),
          );

          expect(EnharmonicNote.f.toNote(), Note.f);
          expect(
            EnharmonicNote.f.toNote(Accidental.sharp),
            const Note(Notes.e, Accidental.sharp),
          );
          expect(
            EnharmonicNote.f.toNote(Accidental.doubleFlat),
            const Note(Notes.g, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.fSharp.toNote(), Note.fSharp);
          expect(EnharmonicNote.fSharp.toNote(Accidental.flat), Note.gFlat);

          expect(EnharmonicNote.g.toNote(), Note.g);
          expect(
            EnharmonicNote.g.toNote(Accidental.doubleSharp),
            const Note(Notes.f, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.g.toNote(Accidental.doubleFlat),
            const Note(Notes.a, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.gSharp.toNote(), Note.gSharp);
          expect(EnharmonicNote.gSharp.toNote(Accidental.flat), Note.aFlat);

          expect(EnharmonicNote.a.toNote(), Note.a);
          expect(
            EnharmonicNote.a.toNote(Accidental.doubleSharp),
            const Note(Notes.g, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.a.toNote(Accidental.doubleFlat),
            const Note(Notes.b, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.aSharp.toNote(), Note.aSharp);
          expect(EnharmonicNote.aSharp.toNote(Accidental.flat), Note.bFlat);

          expect(EnharmonicNote.b.toNote(), Note.b);
          expect(
            EnharmonicNote.b.toNote(Accidental.doubleSharp),
            const Note(Notes.a, Accidental.doubleSharp),
          );
          expect(
            EnharmonicNote.b.toNote(Accidental.flat),
            const Note(Notes.c, Accidental.flat),
          );
        },
      );

      test(
        'should throw an ArgumentError when withAccidental does not match with '
        'any Note',
        () {
          expect(
            () => EnharmonicNote.cSharp.toNote(Accidental.natural),
            throwsArgumentError,
          );
          expect(
            () => EnharmonicNote.c.toNote(Accidental.flat),
            throwsArgumentError,
          );
          expect(
            () => EnharmonicNote.d.toNote(Accidental.sharp),
            throwsArgumentError,
          );
          expect(
            () => EnharmonicNote.a.toNote(Accidental.tripleFlat),
            throwsArgumentError,
          );
        },
      );
    });

    group('.toClosestNote()', () {
      test(
        'should return the Note that matches with the preferred accidental',
        () {
          expect(EnharmonicNote.c.toClosestNote(), Note.c);
          expect(
            EnharmonicNote.c.toClosestNote(Accidental.sharp),
            const Note(Notes.b, Accidental.sharp),
          );
          expect(
            EnharmonicNote.c.toClosestNote(Accidental.doubleFlat),
            const Note(Notes.d, Accidental.doubleFlat),
          );

          expect(EnharmonicNote.cSharp.toClosestNote(), Note.cSharp);
          expect(
            EnharmonicNote.cSharp.toClosestNote(Accidental.flat),
            Note.dFlat,
          );

          // ... Similar to `.toNote()`.
        },
      );

      test(
        'should return the closest Note where a similar call to .toNote() '
        'would throw',
        () {
          expect(
            EnharmonicNote.cSharp.toClosestNote(Accidental.natural),
            Note.cSharp,
          );
          expect(EnharmonicNote.c.toClosestNote(Accidental.flat), Note.c);
          expect(
            EnharmonicNote.d.toClosestNote(Accidental.sharp),
            Note.d,
          );
          expect(
            EnharmonicNote.a.toClosestNote(Accidental.tripleFlat),
            Note.a,
          );
        },
      );
    });

    group('.shortestFifthsDistance()', () {
      test('should return the shortest fifths distance from other', () {
        expect(EnharmonicNote.c.shortestFifthsDistance(EnharmonicNote.c), 0);
        expect(EnharmonicNote.c.shortestFifthsDistance(EnharmonicNote.e), 4);
        expect(
          EnharmonicNote.fSharp.shortestFifthsDistance(EnharmonicNote.a),
          -3,
        );
        expect(
          EnharmonicNote.dSharp.shortestFifthsDistance(EnharmonicNote.g),
          4,
        );
      });
    });

    group('.hashCode', () {
      test('should ignore equal EnharmonicNote instances in a Set', () {
        final collection = {EnharmonicNote.f, EnharmonicNote.aSharp};
        collection.addAll(collection);
        expect(
          collection.toList(),
          const [EnharmonicNote.f, EnharmonicNote.aSharp],
        );
      });
    });

    group('.compareTo()', () {
      test('should correctly sort EnharmonicNote items in a collection', () {
        final orderedSet = SplayTreeSet<EnharmonicNote>.of(const [
          EnharmonicNote.fSharp,
          EnharmonicNote.c,
          EnharmonicNote.d,
        ]);
        expect(orderedSet.toList(), const [
          EnharmonicNote.c,
          EnharmonicNote.d,
          EnharmonicNote.fSharp,
        ]);
      });
    });
  });
}
