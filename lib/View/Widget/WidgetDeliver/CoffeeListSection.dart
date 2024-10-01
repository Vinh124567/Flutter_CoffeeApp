
import 'package:coffee_shop/Model/Cart/cart_response.dart';
import 'package:flutter/material.dart';


class CoffeeListSection extends StatelessWidget {
  final List<CartItemData> cartItems;

  const CoffeeListSection({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: cartItems.map((cartItem) {
        // Lấy coffeeData từ cartItem
        final coffee = cartItem.coffeeData;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  coffee?.coffeeImageUrl ?? '', // Sử dụng giá trị mặc định nếu coffeeData null
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coffee?.coffeeName ?? "Unknown Coffee"), // Hiển thị tên cà phê
                    Text('Size: ${cartItem.size ?? "N/A"}'), // Hiển thị kích thước
                    Text('Quantity: ${cartItem.quantity ?? 0}'), // Hiển thị số lượng
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
