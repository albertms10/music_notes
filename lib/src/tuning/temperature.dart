/// The representation of a Celsius temperature.
extension type const Celsius(num degrees) implements num {
  /// The absolute zero [Celsius] temperature.
  static const zero = Celsius(0);

  /// The reference [Celsius] temperature.
  static const reference = Celsius(20);
}
