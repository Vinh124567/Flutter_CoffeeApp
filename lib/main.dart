import 'package:coffee_shop/ViewModel/auth_view_model.dart';
import 'package:coffee_shop/ViewModel/cartitem_view_model.dart';
import 'package:coffee_shop/ViewModel/home_view_model.dart';
import 'package:coffee_shop/routes/route_name.dart';
import 'package:coffee_shop/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'View/StateDeliverScreen/CoffeeQuantityProvider.dart';
import 'View/Widget/WidgetPaymentScreen/PaymentService.dart';
import 'ViewModel/address_view_model.dart';
import 'ViewModel/payment_view_model.dart';
import 'ViewModel/voucher_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
        ChangeNotifierProvider(create: (_) => PaymentViewModel(PaymentService()))
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xffF9F9F9),
              textTheme: GoogleFonts.soraTextTheme(),
            ),
            // Điều hướng dựa trên trạng thái đăng nhập
            initialRoute: authViewModel.user != null
                ? RouteName.home // Đã đăng nhập -> vào màn hình chính
                : RouteName.onboard, // Chưa đăng nhập -> vào onboard
            onGenerateRoute: Routes.generateRoute,
          );
        },
      ),
    );
  }
}
