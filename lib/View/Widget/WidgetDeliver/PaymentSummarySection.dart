// File: payment_summary_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../StateDeliverScreen/CoffeeQuantityProvider.dart';
import '../../../Model/voucher_dto.dart'; // Đảm bảo import model voucher nếu cần

class PaymentSummarySection extends StatelessWidget {
  final List<Voucher> selectedVouchers; // Thêm biến này để nhận danh sách voucher

  const PaymentSummarySection({Key? key, required this.selectedVouchers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Payment Summary", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Consumer<CoffeeQuantityProvider>(
          builder: (context, coffeeQuantityProvider, child) {
            return Column(
              children: [
                _buildSummaryRow(
                  context,
                  label: "Price:",
                  value: getTotalPrice(coffeeQuantityProvider),
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  context,
                  label: "Total Price after Discount:",
                  value: calculateTotalPrice(coffeeQuantityProvider),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSummaryRow(BuildContext context,
      {required String label, required double value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          NumberFormat.currency(
            decimalDigits: 2,
            locale: 'en_US',
            symbol: '\$ ',
          ).format(value),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xffC67C4E),
          ),
        ),
      ],
    );
  }

  double getTotalPrice(CoffeeQuantityProvider coffeeQuantityProvider) {
    return coffeeQuantityProvider.getTotalPrice();
  }

  double calculateTotalPrice(CoffeeQuantityProvider coffeeQuantityProvider) {
    return coffeeQuantityProvider.calculateTotalPrice(selectedVouchers); // Truyền danh sách voucher vào đây
  }
}
