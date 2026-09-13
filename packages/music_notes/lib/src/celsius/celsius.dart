/// The representation of a Celsius temperature.
extension type const Celsius(num degrees) implements num {
  /// The absolute zero [Celsius] temperature.
  static const zero = Celsius(0);

  /// The reference [Celsius] temperature.
  static const reference = Celsius(20);

  /// Speed of sound at [Celsius.zero] in m/s.
  static const _baseSpeedOfSound = 331.3;

  /// The increase per degree [Celsius] in m/s.
  static const _speedFactorPerDegreeCelsius = 0.6;

  /// The speed of sound in m/s based on [temperature].
  static num _speedOfSoundAt(Celsius temperature) =>
      _baseSpeedOfSound + _speedFactorPerDegreeCelsius * temperature;

  /// The speed of sound ratio between this [Celsius] temperature and
  /// [reference].
  ///
  /// See [Speed of sound in ideal gases and air](https://en.wikipedia.org/wiki/Speed_of_sound#Speed_of_sound_in_ideal_gases_and_air).
  num ratio([Celsius reference = reference]) =>
      _speedOfSoundAt(this) / _speedOfSoundAt(reference);
}
