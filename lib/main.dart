import 'package:coffee_shop/Pages/consts.dart';
import 'package:coffee_shop/ViewModel/auth_view_model.dart';
import 'package:coffee_shop/ViewModel/cartitem_view_model.dart';
import 'package:coffee_shop/ViewModel/home_view_model.dart';
import 'package:coffee_shop/ViewModel/order_view_model.dart';
import 'package:coffee_shop/routes/route_name.dart';
import 'package:coffee_shop/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'View/StateDeliverScreen/CoffeeQuantityProvider.dart';
import 'View/Widget/WidgetPaymentScreen/PaymentService.dart';
import 'ViewModel/address_view_model.dart';
import 'ViewModel/category_view_model.dart';
import 'ViewModel/payment_view_model.dart';
import 'ViewModel/voucher_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _setUp();
  runApp(const MyApp());
}
Future<void> _setUp()async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey=stripePublishableKey;
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()..checkLoginStatus()), // Kiểm tra đăng nhập khi khởi tạo
        ChangeNotifierProvider(create: (_) => VoucherViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => AddressViewModel()),
        ChangeNotifierProvider(create: (_) => CoffeeQuantityProvider()),
        ChangeNotifierProvider(create: (_) => CartItemViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel(PaymentService())),
        ChangeNotifierProvider(create: (_) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel())
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xffF9F9F9),
              textTheme: GoogleFonts.soraTextTheme(),
            ),
            initialRoute: authViewModel.user != null
                ? RouteName.home
                : RouteName.onboard,
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}
