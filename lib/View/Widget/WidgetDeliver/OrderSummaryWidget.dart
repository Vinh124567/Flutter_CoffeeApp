import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/Coffees/coffee_response.dart';
import '../../../Model/voucher_dto.dart';
import '../../StateDeliverScreen/CoffeeQuantityProvider.dart';

class OrderSummaryWidget extends StatelessWidget {
  final List<CoffeeData> coffees;
  final List<Voucher> selectedVouchers;

  const OrderSummaryWidget({
    Key? key,
    required this.coffees,
    required this.selectedVouchers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coffeeQuantityProvider = Provider.of<CoffeeQuantityProvider>(context);

    return Column(
      children: [
        const Text("Payment Summary", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Price: "),
            Text(
              NumberFormat.currency(
                decimalDigits: 2,
                locale: 'en_US',
                symbol: '\$ ',
              ).format(getTotalPrice(coffeeQuantityProvider)),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xffC67C4E),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total Price after Discount: "),
            Text(
              NumberFormat.currency(
                decimalDigits: 2,
                locale: 'en_US',
                symbol: '\$ ',
              ).format(calculateTotalPrice(coffeeQuantityProvider)),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xffC67C4E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  double getTotalPrice(CoffeeQuantityProvider coffeeQuantityProvider) {
    return coffees.fold(0, (sum, coffee) {
      final quantity = coffeeQuantityProvider.getQuantity(coffee);
      return sum + (coffee.coffeePrice ?? 0) * quantity;
    });
  }

  double calculateTotalPrice(CoffeeQuantityProvider coffeeQuantityProvider) {
    double totalPrice = getTotalPrice(coffeeQuantityProvider);

    double totalDiscountPercentage = selectedVouchers.fold(0, (sum, voucher) {
      return sum + (voucher.discount ?? 0);
    });

    return totalPrice * (1 - totalDiscountPercentage / 100);
  }
}
