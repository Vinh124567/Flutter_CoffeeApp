import 'package:coffee_shop/Model/Cart/cart_response.dart';
import 'package:flutter/material.dart';
import 'package:coffee_shop/Model/Coffees/coffee_response.dart';
import 'package:gap/gap.dart';
import '../Widget/WidgetOrderScreen/OrderTabController.dart';

class Order extends StatefulWidget {
  final List<CartItemData> items;
  const Order({super.key,required this.items});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(40), // Khoảng cách trên cùng của màn hình
          Expanded(
            child: OrderTabScreen(items: widget.items),
          ),
        ],
      ),
    );
  }
}

