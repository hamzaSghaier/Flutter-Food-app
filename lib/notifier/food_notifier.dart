import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter_food_hamza/model/food.dart';

class FoodNotifier with ChangeNotifier {
  List<Food> _foodList = [];

  UnmodifiableListView<Food> get foodList {
    return UnmodifiableListView(_foodList);
  }

  set foodList(List<Food> foodList) {
    _foodList = foodList;
    notifyListeners();
  }
}
