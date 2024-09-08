import 'package:coffee_shop/ViewModel/auth_view_model.dart';
import 'package:coffee_shop/ViewModel/home_view_model.dart';
import 'package:coffee_shop/routes/route_name.dart';
import 'package:coffee_shop/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => VoucherViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffF9F9F9),
          textTheme: GoogleFonts.soraTextTheme(),
        ),
        initialRoute: RouteName.onboard,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
