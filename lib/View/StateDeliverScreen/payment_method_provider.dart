import 'package:flutter/foundation.dart';

class PaymentMethodProvider with ChangeNotifier {
  String? _selectedPaymentMethod;

  String? get selectedPaymentMethod => _selectedPaymentMethod;

  void setPaymentMethod(String? method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
}
