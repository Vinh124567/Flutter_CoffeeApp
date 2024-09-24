import 'package:flutter/cupertino.dart';
import '../View/Widget/WidgetPaymentScreen/PaymentService.dart';

class PaymentViewModel with ChangeNotifier {
  final PaymentService _paymentService;
  String _paymentMethod = 'Payment method';  // Khởi tạo với giá trị mặc định

  PaymentViewModel(this._paymentService);

  String get paymentMethod => _paymentMethod;  // Getter để lấy phương thức hiện tại

  Future<void> selectAndProcessPaymentMethod(BuildContext context) async {
    final selectedPaymentMethod = await _paymentService.selectPaymentMethod(context);

    if (selectedPaymentMethod != null) {
      _paymentMethod = selectedPaymentMethod;
      notifyListeners();  // Thông báo UI cần cập nhật

      if (_paymentMethod == 'Thanh toán Online') {
        _paymentService.processOnlinePayment(context);
      } else if (_paymentMethod == 'Thanh toán tại nhà') {
        _paymentService.processPaymentAtHome(context);
      }
    }
  }
}

// import 'package:flutter/cupertino.dart';
// import '../View/Widget/WidgetPaymentScreen/PaymentService.dart';
//
// class PaymentViewModel with ChangeNotifier {
//   final PaymentService _paymentService;
//   String _selectedPaymentMethod = 'Cash'; // Khởi tạo với giá trị mặc định
//   List<String> _paymentMethods = ["Cash", "Credit Card", "PayPal"]; // Danh sách phương thức thanh toán
//
//   PaymentViewModel(this._paymentService);
//
//   // Getter để lấy phương thức thanh toán hiện tại
//   String get selectedPaymentMethod => _selectedPaymentMethod;
//
//   // Getter để lấy danh sách phương thức thanh toán
//   List<String> get paymentMethods => _paymentMethods;
//
//   // Setter để thay đổi phương thức thanh toán
//   void setPaymentMethod(String method) {
//     _selectedPaymentMethod = method;
//     notifyListeners(); // Thông báo UI cần cập nhật
//   }
//
//   Future<void> selectAndProcessPaymentMethod(BuildContext context) async {
//     final selectedPaymentMethod = await _paymentService.selectPaymentMethod(context);
//
//     if (selectedPaymentMethod != null) {
//       _selectedPaymentMethod = selectedPaymentMethod;
//       notifyListeners(); // Thông báo UI cần cập nhật
//
//       if (_selectedPaymentMethod == 'Thanh toán Online') {
//         _paymentService.processOnlinePayment(context);
//       } else if (_selectedPaymentMethod == 'Thanh toán tại nhà') {
//         _paymentService.processPaymentAtHome(context);
//       }
//     }
//   }
// }
