import 'package:coffee_shop/Model/Cart/cart_response.dart';
import 'package:coffee_shop/View/StateDeliverScreen/voucher_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/voucher_dto.dart';

class PaymentSummaryWidget extends StatelessWidget {
  final List<CartItemData>? items;

  const PaymentSummaryWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VoucherProvider>(
      builder: (context, voucherProvider, child) {
        List<Voucher> vouchers = voucherProvider.selectedVouchers;

        double originalPrice = items?.fold(0.0, (sum, item) {
          double itemPrice = (item.coffeeData?.coffeePrice ?? 0) * (item.quantity ?? 1);
          return sum! + itemPrice;
        }) ?? 0.0;

        double totalDiscount = _calculateTotalDiscount(vouchers, originalPrice);
        totalDiscount = totalDiscount > originalPrice ? originalPrice : totalDiscount;

        double totalPriceAfterDiscount = originalPrice - totalDiscount;

        // Cập nhật thông tin thanh toán vào provider
        WidgetsBinding.instance.addPostFrameCallback((_) {
          voucherProvider.updatePaymentSummary(originalPrice, totalDiscount, totalPriceAfterDiscount);
        });

        return Column(
          children: [
            const Text("Payment Summary", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Column(
              children: [
                _buildSummaryRow(
                  context,
                  label: "Original Price:",
                  value: originalPrice,
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  context,
                  label: vouchers.isEmpty ? "No Vouchers Applied" : "Total Discount:",
                  value: totalDiscount,
                ),
                const SizedBox(height: 10),
                _buildSummaryRow(
                  context,
                  label: "Total Price after Discount:",
                  value: totalPriceAfterDiscount,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalDiscount(List<Voucher> vouchers, double originalPrice) {
    return vouchers.fold(0.0, (sum, voucher) {
      double discountAmount = (voucher.discount ?? 0) * originalPrice / 100;
      return sum + discountAmount;
    });
  }

  Widget _buildSummaryRow(BuildContext context, {required String label, required double value}) {
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
}
