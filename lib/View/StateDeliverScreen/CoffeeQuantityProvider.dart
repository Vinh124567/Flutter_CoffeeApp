import 'package:flutter/material.dart';
import '../../../Model/coffee_dto.dart';
import '../../Model/voucher_dto.dart';

class CoffeeQuantityProvider with ChangeNotifier {
  List<Coffee> _coffees = [];
  final Map<Coffee, int> _quantities = {};
  List<Coffee> get coffees => _coffees;
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

  double getTotalPrice() {
    double total = 0.0;
    _quantities.forEach((coffee, quantity) {
      total += (coffee.price ?? 0) * quantity;
    });
    return total;
  }

  double calculateTotalPrice(List<Voucher> selectedVouchers) {
    double total = getTotalPrice();
    double totalDiscountPercentage = getTotalDiscountPercentage(selectedVouchers);
    double discountedPrice = total * (1 - totalDiscountPercentage / 100);
    return discountedPrice;
  }

  double getTotalDiscountPercentage(List<Voucher> selectedVouchers) {
    // Tính tổng giảm giá phần trăm từ danh sách voucher đã chọn
    double totalDiscount = 0.0;
    for (var voucher in selectedVouchers) {
      totalDiscount += (voucher.discount ?? 0);
    }
    return totalDiscount;
  }
}
