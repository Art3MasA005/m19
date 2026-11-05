import 'package:calorie_tracker/src/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('calorie labels keep small positive amounts readable', () {
    expect(formatCalories(2000), '2,000');
    expect(formatCalories(0.01), '0.01');
    expect(formatCalories(0.1 + 0.2), '0.3');
  });
}
