import 'dart:collection' show SplayTreeSet;

import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('EnharmonicNote', () {
    group('.items', () {
      test('should return the correct notes for this EnharmonicNote', () {
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
        expect(collection, {EnharmonicNote.f, EnharmonicNote.aSharp});
      });
    });

    group('.compareTo()', () {
      test('should correctly sort EnharmonicNote items in a collection', () {
        final orderedSet = SplayTreeSet<EnharmonicNote>.of([
          EnharmonicNote.fSharp,
          EnharmonicNote.c,
          EnharmonicNote.d,
        ]);
        expect(orderedSet.toList(), [
          EnharmonicNote.c,
          EnharmonicNote.d,
          EnharmonicNote.fSharp,
        ]);
      });
    });
  });
}
