import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ViewModel/payment_view_model.dart';

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
        paymentViewModel.selectAndProcessPaymentMethod(context);
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.payment, size: 20),
            Consumer<PaymentViewModel>(
              builder: (context, paymentViewModel, child) {
                return Text(paymentViewModel.paymentMethod);
              },
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
