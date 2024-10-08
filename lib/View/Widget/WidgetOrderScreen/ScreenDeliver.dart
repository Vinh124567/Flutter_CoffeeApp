import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Data/Network/stripe_service.dart';
import '../../../Data/Response/status.dart';
import '../../../Model/Cart/cart_response.dart';
import '../../../Model/Enum/OrderStatus.dart';
import '../../../Model/Enum/payment_status.dart';
import '../../../Model/Order/order_create_request.dart';
import '../../../Model/Order/order_item_dto.dart';
import '../../../ViewModel/address_view_model.dart';
import '../../../ViewModel/auth_view_model.dart';
import '../../../ViewModel/order_view_model.dart';
import '../../../routes/route_name.dart';
import '../../StateDeliverScreen/note_provider.dart';
import '../../StateDeliverScreen/payment_method_provider.dart';
import '../../StateDeliverScreen/voucher_provider.dart';
import '../WidgetDeliver/address.dart';
import '../WidgetDeliver/items.dart';
import '../WidgetDeliver/payment_sumary.dart';
import '../WidgetDeliver/voucher.dart';

class Deliver extends StatefulWidget {
  final List<CartItemData> items;

  const Deliver({super.key, required this.items});

  @override
  _DeliverState createState() => _DeliverState();
}

class _DeliverState extends State<Deliver> {
  @override
  Widget build(BuildContext context) {
    final paymentMethodProvider = Provider.of<PaymentMethodProvider>(context);
    final addressViewModel = Provider.of<AddressViewModel>(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AddressSection(),
                    const SizedBox(height: 15),
                    Divider(color: Colors.grey.shade300, thickness: 2),
                    const SizedBox(height: 15),
                    ItemList(cartItems: widget.items),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade300, thickness: 2),
                    const SizedBox(height: 20),
                    VoucherWidget(),
                    const SizedBox(height: 10),
                    // Payment Method Selection
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RouteName.payment);
                      },
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0),
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
                            Consumer<PaymentMethodProvider>(
                              builder: (context, provider, child) {
                                return Text(
                                  provider.selectedPaymentMethod?.isNotEmpty ==
                                      true
                                      ? provider.selectedPaymentMethod!
                                      : "Phương thức thanh toán",
                                );
                              },
                            ),
                            const Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade300, thickness: 2),
                    PaymentSummaryWidget(items: widget.items),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildPrice(context, paymentMethodProvider,addressViewModel),
    );
  }

  Widget buildPrice(BuildContext context, PaymentMethodProvider paymentMethodProvider,AddressViewModel addressViewModel) {
    return Consumer5<AuthViewModel,
        OrderViewModel,
        VoucherProvider,
        NoteProvider,
        AddressViewModel>(
      builder: (context, authViewModel, orderViewModel, voucherProvider,
          noteProvider, addressViewModel, child) {
        double? totalPrice = voucherProvider.totalPriceAfterDiscount;
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    NumberFormat.currency(
                      decimalDigits: 2,
                      locale: 'en_US',
                      symbol: '\$ ',
                    ).format(totalPrice),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffC67C4E),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  // Kiểm tra xem có phương thức thanh toán được chọn không
                  final bool isPaymentMethodNotSelected = paymentMethodProvider.selectedPaymentMethod == null ||
                      paymentMethodProvider.selectedPaymentMethod!.isEmpty;

                  final bool isAddressNotSelected = addressViewModel.selectedAddress == null;

                  if (isPaymentMethodNotSelected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng chọn phương thức thanh toán!")),
                    );
                    return; // Ngừng thực hiện nếu không có phương thức thanh toán
                  }
                  if (isAddressNotSelected) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Vui lòng chọn địa chỉ giao hàng!")),
                    );
                    return; // Ngừng thực hiện nếu không có địa chỉ giao hàng
                  }


                  bool paymentSuccess = false;

                  if (paymentMethodProvider.selectedPaymentMethod == "Thanh toán Online") {
                    // Gọi thanh toán Stripe
                    paymentSuccess = await StripeService.instance.makePayment();
                    if (!paymentSuccess) {
                      // Thanh toán thất bại, hiển thị thông báo
                      print("Thanh toán không thành công!");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Thanh toán không thành công!")),
                      );
                      return; // Ngừng thực hiện nếu thanh toán thất bại
                    }
                  }

                  // Tạo đơn hàng bất kể phương thức thanh toán
                  await _createOrder(
                    authViewModel,
                    orderViewModel,
                    voucherProvider,
                    noteProvider,
                    addressViewModel,
                    paymentMethodProvider,
                    paymentSuccess,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffC67C4E),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _createOrder(AuthViewModel authViewModel,
  //     OrderViewModel orderViewModel,
  //     VoucherProvider voucherProvider,
  //     NoteProvider noteProvider,
  //     AddressViewModel addressViewModel,
  //     PaymentMethodProvider paymentMethodProvider,
  //     bool paymentSuccess) async {
  //   OrderCreateRequest requestOrder = OrderCreateRequest()
  //     ..userId = authViewModel.user?.uid.toString()
  //     ..paymentStatus = paymentMethodProvider.selectedPaymentMethod == "Thanh toán Online" && paymentSuccess
  //         ? PaymentStatus.paid.value // Nếu thanh toán online và thành công
  //         : PaymentStatus.not_yet_paid.value // Nếu là thanh toán khi giao hàng hoặc thanh toán online thất bại
  //     ..notes = noteProvider.note.toString()
  //     ..orderItems = widget.items.map((item) => OrderItemDTO(
  //       coffeeId: item.coffeeData?.coffeeId ?? 0,
  //       quantity: item.quantity ?? 1,
  //       size: item.size ?? "",
  //     )).toList()
  //     ..totalPrice = voucherProvider.originalPrice
  //     ..voucherCodes = voucherProvider.getVoucherCodes().cast<String>()
  //     ..userAddressId = addressViewModel.selectedAddress?.id
  //     ..status = OrderStatus.pending.value
  //   ..totalAfterDiscount=voucherProvider.totalPriceAfterDiscount
  //   ..discountAmount=voucherProvider.totalDiscount;
  //
  //   print("Request order: $requestOrder");
  //
  //   // Gọi API và nhận phản hồi
  //   var response = await orderViewModel.newOrderApi(requestOrder);
  //   // Xử lý phản hồi từ API
  //   if (response.status == Status.COMPLETED) {
  //     print("Order created successfully!");
  //     Navigator.pushNamed(context, RouteName.receipt);
  //   } else if (response.status == Status.ERROR) {
  //     print("Failed to create order: ${response.message}");
  //     // Hiển thị thông báo lỗi
  //   }
  // }

  Future<void> _createOrder(
      AuthViewModel authViewModel,
      OrderViewModel orderViewModel,
      VoucherProvider voucherProvider,
      NoteProvider noteProvider,
      AddressViewModel addressViewModel,
      PaymentMethodProvider paymentMethodProvider,
      bool paymentSuccess) async {

    OrderCreateRequest requestOrder = OrderCreateRequest()
      ..userId = authViewModel.user?.uid.toString()
      ..paymentStatus = paymentMethodProvider.selectedPaymentMethod == "Thanh toán Online" && paymentSuccess
          ? PaymentStatus.paid.value
          : PaymentStatus.not_yet_paid.value
      ..notes = noteProvider.note.toString()
      ..orderItems = widget.items.map((item) => OrderItemDTO(
        coffeeId: item.coffeeData?.coffeeId ?? 0,
        quantity: item.quantity ?? 1,
        size: item.size ?? "",
      )).toList()
      ..totalPrice = voucherProvider.originalPrice
      ..voucherCodes = voucherProvider.getVoucherCodes().cast<String>()
      ..userAddressId = addressViewModel.selectedAddress?.id
      ..status = OrderStatus.pending.value
      ..totalAfterDiscount = voucherProvider.totalPriceAfterDiscount
      ..discountAmount = voucherProvider.totalDiscount;

    print("Request order: $requestOrder");

    // Gọi API và nhận phản hồi
    var response = await orderViewModel.newOrderApi(requestOrder);

    // Xử lý phản hồi từ API
    if (response.status == Status.COMPLETED) {
      print("Order created successfully!");

      // Đặt lại các giá trị về null hoặc giá trị mặc định
      paymentMethodProvider.setPaymentMethod(null);
      addressViewModel.setSelectedAddress(null);
      voucherProvider.clearVouchers(); // Giả sử bạn có phương thức để reset voucher

      // Điều hướng sang màn hình hóa đơn
      Navigator.pushNamed(context, RouteName.receipt);
    } else if (response.status == Status.ERROR) {
      print("Failed to create order: ${response.message}");
      // Hiển thị thông báo lỗi
    }
  }

}
