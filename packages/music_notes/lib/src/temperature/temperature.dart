/// The representation of a Celsius temperature.
extension type const Temperature._(num celsius) implements num {
  /// Creates a new [Temperature] from Celsius.
  const Temperature.celsius(this.celsius);

  /// Creates a new [Temperature] from Fahrenheit.
  const Temperature.fahrenheit(num fahrenheit)
    : this.celsius((fahrenheit - 32) * 5 / 9);

  /// Creates a new [Temperature] from Kelvin.
  const Temperature.kelvin(num kelvin) : this.celsius(kelvin - 273.15);

  /// The absolute zero Celsius temperature.
  static const zero = Temperature.celsius(0);

  /// The reference [Temperature] temperature.
  static const reference = Temperature.celsius(20);

  /// Speed of sound at [Temperature.zero] in m/s.
  static const _baseSpeedOfSound = 331.3;

  /// The increase per degree [Temperature] in m/s.
  static const _speedFactorPerDegreeCelsius = 0.6;

  /// The speed of sound in m/s based on [temperature].
  static num _speedOfSoundAt(Temperature temperature) =>
      _baseSpeedOfSound + _speedFactorPerDegreeCelsius * temperature;

  /// The speed of sound ratio between this [Temperature] temperature and
  /// [reference].
  ///
  /// See [Speed of sound in ideal gases and air](https://en.wikipedia.org/wiki/Speed_of_sound#Speed_of_sound_in_ideal_gases_and_air).
  num ratio([Temperature reference = reference]) =>
      _speedOfSoundAt(this) / _speedOfSoundAt(reference);
}
