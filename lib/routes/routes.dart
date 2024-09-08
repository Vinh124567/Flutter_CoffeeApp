import 'package:coffee_shop/View/Screen/dashboard_page.dart';
import 'package:coffee_shop/View/Screen/detail_screen.dart';
import 'package:coffee_shop/View/Screen/onboard_page.dart';
import 'package:coffee_shop/routes/route_name.dart';
import 'package:flutter/material.dart';
import '../Model/coffee_dto.dart';
import '../Model/voucher_dto.dart';
import '../View/Screen/address_page.dart';
import '../View/Screen/login_screen.dart';
import '../View/Screen/order_screen.dart';
import '../View/Screen/voucher_screen.dart';

class Routes {

  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch(setting.name) {
      case RouteName.login:
        return MaterialPageRoute(builder: (BuildContext context) => const Login());
      case RouteName.home:
        return MaterialPageRoute(builder: (BuildContext context) => const DashboardPage());
      case RouteName.voucher:
        final List<Voucher> selectedVouchers = setting.arguments as List<Voucher>;
        return MaterialPageRoute(
          builder: (BuildContext context) => VoucherScreen(selectedVouchers: selectedVouchers),
        );
      case RouteName.onboard:
        return MaterialPageRoute(builder: (BuildContext context) => const OnboardPage());
      case RouteName.address:
        return MaterialPageRoute(builder: (BuildContext context) => const AddressPage());
      case RouteName.detail:
        final Coffee coffee = setting.arguments as Coffee;
        return MaterialPageRoute(builder: (BuildContext context) => DetailPage(coffee: coffee));
      case RouteName.order:
        final Coffee coffee = setting.arguments as Coffee;
        return MaterialPageRoute(builder: (BuildContext context) => Order(coffee: coffee));
      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }
  }
}

