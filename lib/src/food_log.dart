import 'package:flutter/foundation.dart';

import 'food_item.dart';

class FoodLog extends ChangeNotifier {
  final List<FoodItem> _foods = [];
  DateTime _today = DateTime.now();
  int _nextId = 1;

  DateTime get today => _today;
  List<FoodItem> get foods => List.unmodifiable(_foods);
  double get totalCalories =>
      _foods.fold(0, (sum, food) => sum + food.calories);

  void refreshDay() {
    final now = DateTime.now();
    if (now.year == _today.year &&
        now.month == _today.month &&
        now.day == _today.day) {
      return;
    }
    _today = now;
    _foods.clear();
    notifyListeners();
  }

  void addFood(String name, double calories) {
    refreshDay();
    _foods.add(FoodItem(id: _nextId++, name: name, calories: calories));
    notifyListeners();
  }

  void deleteFood(int id) {
    refreshDay();
    final originalLength = _foods.length;
    _foods.removeWhere((food) => food.id == id);
    if (_foods.length != originalLength) notifyListeners();
  }
}
