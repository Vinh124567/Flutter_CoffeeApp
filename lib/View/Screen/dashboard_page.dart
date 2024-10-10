
import 'package:coffee_shop/View/Screen/cart_page.dart';
import 'package:coffee_shop/View/Screen/my_order_page.dart';
import 'package:coffee_shop/View/Screen/user_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../Widget/WidgetMyOrder/tab_bar.dart';
import 'home_screen.dart';

class DashboardPage extends StatefulWidget {
  final int initialIndex; // Tham số để nhận chỉ số của menu

  const DashboardPage({Key? key, this.initialIndex = 0}) : super(key: key);
  // const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int indexMenu = 0;
  final menu = [
    {
      'icon': 'assets/images/ic_home_border.png',
      'icon_active': 'assets/images/ic_home_filled.png',
      'fragment': const HomeFragment(),
    },
    {
      'icon': 'assets/images/shipped.png',
      'icon_active': 'assets/images/shipped.png',
      'fragment': MyOrderPage() ,
    },
    {
      'icon': 'assets/images/ic_bag_border.png',
      'icon_active': 'assets/images/ic_bag_border.png',
      'fragment': const CartPage(),
    },
    {
      'icon': 'assets/images/ic_notification_border.png',
      'icon_active': 'assets/images/ic_notification_border.png',
      'fragment':  UserScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: menu[indexMenu]['fragment'] as Widget,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: List.generate(menu.length, (index) {
            Map item = menu[index];
            bool isActive = indexMenu == index;
            return Expanded(
              child: InkWell(
                onTap: () {
                  indexMenu = index;
                  setState(() {});
                },
                child: SizedBox(
                  height: 70,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(20),
                      ImageIcon(
                        AssetImage(
                          item[isActive ? 'icon_active' : 'icon'],
                        ),
                        size: 24,
                        color: Color(isActive ? 0xffC67C4E : 0xffA2A2A2),
                      ),
                      if (isActive) const Gap(6),
                      if (isActive)
                        Container(
                          height: 5,
                          width: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xffC67C4E),
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
