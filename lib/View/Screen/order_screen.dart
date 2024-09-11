import 'package:flutter/material.dart';
import 'package:coffee_shop/Model/coffee_dto.dart';
import 'package:gap/gap.dart';
import '../Widget/WidgetOrderScreen/OrderTabController.dart';

class Order extends StatefulWidget {
  final List<Coffee> coffees;
  const Order({super.key,required this.coffees});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(40), // Khoảng cách trên cùng của màn hình
          Expanded(
            child: OrderTabScreen(coffees: widget.coffees),
          ),
        ],
      ),
    );
  }
}

