import 'package:xml/xml.dart' show XmlDocument;

import 'notation_system.dart';

/// The stringified [XmlDocument] Notation system representation of [V].
final class StringXmlNotationSystem<V> extends StringNotationSystem<V> {
  /// The wrapped XML [NotationSystem].
  final NotationSystem<V, XmlDocument> notationSystem;

  /// Creates a new [StringXmlNotationSystem].
  const StringXmlNotationSystem(this.notationSystem);

  @override
  V parse(String source) => source.trim().isEmpty
      ? throw ArgumentError('Empty XML document.')
      : notationSystem.parse(XmlDocument.parse(source));

  @override
  String format(V value) =>
      notationSystem.format(value).toXmlString(pretty: true);
}
