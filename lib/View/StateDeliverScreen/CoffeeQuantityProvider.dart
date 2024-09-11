import 'package:flutter/material.dart';
import '../../../Model/coffee_dto.dart';

class CoffeeQuantityProvider with ChangeNotifier {
  List<Coffee> _coffees = [];
  Map<Coffee, int> _quantities = {};

  // Define the initialize method
  void initialize(List<Coffee> coffees) {
    _coffees = coffees;
    // Initialize quantities for each coffee to 0
    for (var coffee in coffees) {
      _quantities[coffee] = 1;
    }
    notifyListeners();
  }

  int getQuantity(Coffee coffee) {
    return _quantities[coffee] ?? 1;
  }

  void increaseQuantity(Coffee coffee) {
    if (_quantities.containsKey(coffee)) {
      _quantities[coffee] = (_quantities[coffee] ?? 1) + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(Coffee coffee) {
    if (_quantities.containsKey(coffee) && (_quantities[coffee] ?? 1) > 1) {
      _quantities[coffee] = (_quantities[coffee] ?? 1) - 1;
      notifyListeners();
    }
  }
}
