import 'package:coffee_shop/Model/Enum/OrderStatus.dart';
import 'package:coffee_shop/View/Screen/cart_page.dart';
import 'package:coffee_shop/View/Screen/user_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../Screen/coffee_review_page.dart';
import '../../Screen/my_order_page.dart';

class MyOrderPage extends StatelessWidget {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Cập nhật số tab ở đây
      child: Scaffold(
        body: Column(
          children: [
            Gap(68),
            TabBar(
              isScrollable: true, // Cho phép kéo ngang
              tabs: [
                Tab(child: Text("Đang chuẩn bị", style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(child: Text("Đang giao", style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(child: Text("Đã giao", style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(child: Text("Đã hủy", style: TextStyle(fontWeight: FontWeight.bold))),
                Tab(child: Text("Đánh giá", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DeliveredPage(orderStatus: OrderStatus.pending),
                  DeliveredPage(orderStatus: OrderStatus.shipped),
                  DeliveredPage(orderStatus: OrderStatus.delivered),
                  DeliveredPage(orderStatus: OrderStatus.cancelled),
                  CoffeeReviewPage(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
