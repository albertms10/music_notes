import 'package:music_notes/music_notes.dart';
import 'package:test/test.dart';

void main() {
  group('TuningSystem', () {
    group('.cents()', () {
      test('should return the number of cents for ratio in a TuningSystem', () {
        const edo12 = EqualTemperament.edo12();
        expect(TuningSystem.cents(edo12.ratio()), closeTo(100, 0.01));
        expect(TuningSystem.cents(edo12.ratio(6)), closeTo(600, 0.01));
        expect(TuningSystem.cents(edo12.ratio(12)), closeTo(1200, 0.01));

        const edo19 = EqualTemperament.edo19();
        expect(TuningSystem.cents(edo19.ratio()), closeTo(63.16, 0.01));
        expect(TuningSystem.cents(edo19.ratio(10)), closeTo(631.58, 0.01));
        expect(TuningSystem.cents(edo19.ratio(19)), closeTo(1200, 0.01));
      });
    });
  });
}
