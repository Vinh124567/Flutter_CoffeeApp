import 'package:coffee_shop/Pages/consts.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();
  Future<bool> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        10,
        "usd",
      );
      if (paymentIntentClientSecret != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentClientSecret,
              merchantDisplayName: "Hussain Mustafa",
            ));
        await _processPayment();
        return true; // Thanh toán thành công
      }
    } catch (e) {
      print(e);
    }
    return false; // Thanh toán thất bại
  }


  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer ${stripeSecretcKey}",
            "Content-Type": 'application/x-www-form-urlencoded'
          },),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calculateAmount = amount * 100;
    return calculateAmount.toString();
  }
}
