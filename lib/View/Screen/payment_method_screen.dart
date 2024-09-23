import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Biến để lưu phương thức thanh toán được chọn
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn Phương Thức Thanh Toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // RadioButton cho thanh toán online
            RadioListTile<String>(
              title: const Text('Thanh toán Online'),
              value: 'Thanh toán Online',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            // RadioButton cho thanh toán tại nhà
            RadioListTile<String>(
              title: const Text('Thanh toán Tại Nhà'),
              value: 'Thanh toán tại nhà',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // Nút Xác nhận
            ElevatedButton(
              onPressed: () {
                if (_selectedPaymentMethod != null) {
                  Navigator.pop(context, _selectedPaymentMethod);  // Trả về phương thức thanh toán đã chọn
                } else {
                  // Hiển thị thông báo nếu chưa chọn phương thức
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng chọn phương thức thanh toán'),
                    ),
                  );
                }
              },
              child: const Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
