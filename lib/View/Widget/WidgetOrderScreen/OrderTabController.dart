import 'package:coffee_shop/Model/Cart/cart_response.dart';
import 'package:flutter/material.dart';
import '../../../Model/Coffees/coffee_response.dart';
import 'ScreenDeliver.dart';
import 'TabItem.dart';

class OrderTabScreen extends StatelessWidget {
  final List<CartItemData> items;

  const OrderTabScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Order", style: TextStyle(fontSize: 16)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const ImageIcon(
              AssetImage('assets/images/ic_arrow_left.png'),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Container(
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.shade300,
              ),
              child: const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  TabItem(title: 'Deliver'),
                  TabItem(title: 'Pick Up'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Deliver(items: items)),
            const Center(child: Text('Pick Up Tab Content')),
          ],
        ),
      ),
    );
  }
}
