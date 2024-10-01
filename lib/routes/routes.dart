import 'package:coffee_shop/Model/Cart/cart_response.dart';
import 'package:coffee_shop/View/Screen/add_address_page.dart';
import 'package:coffee_shop/View/Screen/cart_screen.dart';
import 'package:coffee_shop/View/Screen/dashboard_page.dart';
import 'package:coffee_shop/View/Screen/detail_screen.dart';
import 'package:coffee_shop/View/Screen/onboard_page.dart';
import 'package:coffee_shop/View/Screen/receip_page.dart';
import 'package:coffee_shop/View/Screen/payment_method_screen.dart';
import 'package:coffee_shop/routes/route_name.dart';
import 'package:flutter/material.dart';
import '../Model/address_dto.dart';
import '../Model/Coffees/coffee_response.dart';
import '../Model/voucher_dto.dart';
import '../View/Screen/RegisterScreen.dart';
import '../View/Screen/address_page.dart';
import '../View/Screen/login_screen.dart';
import '../View/Screen/order_screen.dart';
import '../View/Screen/voucher_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case RouteName.login:
        return MaterialPageRoute(builder: (BuildContext context) => const Login());
      case RouteName.receipt:
        return MaterialPageRoute(builder: (BuildContext context) => ReceiptScreen());
      case RouteName.register:
        return MaterialPageRoute(builder: (BuildContext context) => const Register());
      case RouteName.home:
        return MaterialPageRoute(builder: (BuildContext context) => const DashboardPage());
      case RouteName.cart:
        return MaterialPageRoute(builder: (BuildContext context) =>  const CartPage());
      case RouteName.newaddress:
        return MaterialPageRoute(builder: (BuildContext context) => const AddAddressScreen());
      case RouteName.payment:
        return MaterialPageRoute(builder: (BuildContext context) => PaymentMethodScreen());
      case RouteName.voucher:
        final List<Voucher> selectedVouchers = setting.arguments as List<Voucher>;
        return MaterialPageRoute(
          builder: (BuildContext context) => VoucherScreen(selectedVouchers: selectedVouchers),
        );
      case RouteName.onboard:
        return MaterialPageRoute(builder: (BuildContext context) => const OnboardPage());
      case RouteName.address:
        final Address? selectedAddress = setting.arguments as Address?;
        return MaterialPageRoute(
          builder: (BuildContext context) => AddressPage(selectedAddress: selectedAddress),
        );
      case RouteName.detail:
        final CoffeeData coffee = setting.arguments as CoffeeData;
        return MaterialPageRoute(builder: (BuildContext context) => DetailPage(coffee: coffee),);

      case RouteName.order:
      // Nhận danh sách Coffee từ arguments
        final List<CartItemData> items = setting.arguments as List<CartItemData>;
        return MaterialPageRoute(
          builder: (BuildContext context) => Order(items: items),
        );

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text("No route defined"),
            ),
          );
        });
    }
  }
}


