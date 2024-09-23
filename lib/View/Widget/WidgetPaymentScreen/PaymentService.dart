import 'package:flutter/material.dart';

import '../../Screen/payment_method_screen.dart';

class PaymentService {
  // Hàm để chọn phương thức thanh toán
  Future<String?> selectPaymentMethod(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodScreen()),
    );
  }

  // Hàm xử lý thanh toán online
  void processOnlinePayment(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thanh Toán Online'),
          content: const Text('Thực hiện demo thanh toán online.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Đóng dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Hàm xử lý thanh toán tại nhà
  void processPaymentAtHome(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thanh Toán Tại Nhà'),
          content: const Text('Đơn hàng sẽ được thanh toán khi giao hàng.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Đóng dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
