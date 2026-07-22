import 'package:xml/xml.dart';

import '../accidental/accidental.dart';
import '../notation_system/notation_system.dart';
import '../note/note.dart';
import '../note_name/english_note_name_notation.dart';
import '../note_name/note_name.dart';
import 'pitch.dart';

/// The MusicXML representation of a [Pitch].
class MusicXmlPitchNotation extends NotationSystem<Pitch, XmlDocument> {
  /// The [StringNotationSystem] for [NoteName].
  final StringNotationSystem<NoteName> noteNameNotation;

  /// Creates a new [MusicXmlPitchNotation].
  const MusicXmlPitchNotation({
    this.noteNameNotation = const EnglishNoteNameNotation(),
  });

  static const _pitch = 'pitch';
  static const _step = 'step';
  static const _alter = 'alter';
  static const _octave = 'octave';

  static Never _required(String elementName) =>
      throw ArgumentError('Missing required <$elementName> element.');

  @override
  Pitch parse(XmlDocument source) {
    final pitch = source.getElement(_pitch) ?? _required(_pitch);
    final step = pitch.getElement(_step)?.innerText ?? _required(_step);
    final alter = pitch.getElement(_alter)?.innerText ?? '0';
    final octave = pitch.getElement(_octave)?.innerText ?? _required(_octave);

    return Pitch(
      Note(noteNameNotation.parse(step), Accidental(.parse(alter))),
      octave: .parse(octave),
    );
  }

  @override
  XmlDocument format(Pitch pitch) {
    final builder = XmlBuilder();
    builder.element(
      _pitch,
      nest: () => builder
        ..element(_step, nest: noteNameNotation.format(pitch.note.noteName))
        ..element(_alter, nest: pitch.note.accidental.semitones)
        ..element(_octave, nest: pitch.octave),
    );
    return builder.buildDocument();
  }
}
