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
