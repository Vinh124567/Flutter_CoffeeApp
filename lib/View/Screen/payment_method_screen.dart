import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../StateDeliverScreen/payment_method_provider.dart';
import '../Widget/button_primary.dart'; // Đảm bảo bạn đã tạo Widget button_primary

class PaymentMethodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(68),
          buildHeader(context), // Truyền context vào đây
          const Gap(24),
          buildPaymentMethodOptions(context),
          const SizedBox(height: 20),
          buildConfirmButton(context),
        ],
      ),
    );
  }

  // Cập nhật để nhận context
  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Text(
          'Chọn Phương Thức Thanh Toán',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        const SizedBox(width: 48), // Để cân bằng với IconButton
      ],
    );
  }

  Widget buildPaymentMethodOptions(BuildContext context) {
    return Column(
      children: [
        // RadioButton cho thanh toán online
        RadioListTile<String>(
          title: const Text('Thanh toán Online'),
          value: 'Thanh toán Online',
          groupValue: Provider.of<PaymentMethodProvider>(context).selectedPaymentMethod,
          onChanged: (value) {
            Provider.of<PaymentMethodProvider>(context, listen: false).setPaymentMethod(value);
          },
        ),
        // RadioButton cho thanh toán tại nhà
        RadioListTile<String>(
          title: const Text('Thanh toán Tại Nhà'),
          value: 'Thanh toán tại nhà',
          groupValue: Provider.of<PaymentMethodProvider>(context).selectedPaymentMethod,
          onChanged: (value) {
            Provider.of<PaymentMethodProvider>(context, listen: false).setPaymentMethod(value);
          },
        ),
      ],
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Để nút rộng toàn bộ chiều rộng
      child: ButtonPrimary(
        title: 'Xác nhận',
        onTap: () {
          final selectedMethod = Provider.of<PaymentMethodProvider>(context, listen: false).selectedPaymentMethod;
          if (selectedMethod != null) {
            Navigator.pop(context, selectedMethod); // Trả về phương thức thanh toán đã chọn
          } else {
            // Hiển thị thông báo nếu chưa chọn phương thức
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vui lòng chọn phương thức thanh toán'),
              ),
            );
          }
        },
      ),
    );
  }
}
