import 'package:xml/xml.dart' show XmlDocument;

import 'notation_system.dart';

/// The stringified [XmlDocument] Notation system representation of [I].
final class StringXmlNotationSystem<I> extends StringNotationSystem<I> {
  /// The wrapped [NotationSystem].
  final NotationSystem<I, XmlDocument> notationSystem;

  /// Creates a new [StringXmlNotationSystem].
  const StringXmlNotationSystem(this.notationSystem);

  @override
  String format(I pitch) =>
      notationSystem.format(pitch).toXmlString(pretty: true);

  @override
  I parse(String source) => source.trim().isEmpty
      ? throw ArgumentError('Empty XML document.')
      : notationSystem.parse(XmlDocument.parse(source));
}
