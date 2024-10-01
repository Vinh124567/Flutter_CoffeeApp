import 'package:coffee_shop/Model/Cart/cart_response.dart';
import 'package:coffee_shop/ViewModel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/order_dto.dart';
import '../../../Model/voucher_dto.dart';
import '../../../Model/address_dto.dart';
import '../../../ViewModel/auth_view_model.dart';
import '../../../ViewModel/payment_view_model.dart';
import '../../StateDeliverScreen/CoffeeQuantityProvider.dart';
import '../WidgetDeliver/AddressSection.dart';
import '../WidgetDeliver/CoffeeListSection.dart';
import '../WidgetDeliver/PaymentSummarySection.dart';
import '../WidgetDeliver/VoucherSection.dart';

class Deliver extends StatefulWidget {
  final List<CartItemData> items;

  const Deliver({super.key, required this.items});

  @override
  _DeliverState createState() => _DeliverState();
}

class _DeliverState extends State<Deliver> {
  OrderDTO? orderDTO;
  List<Voucher> selectedVouchers = [];
  Address? _selectedAddress;
  String note = '';
  List<OrderItem> orderItems = [];
  List<String> voucherCode = [];
  final TextEditingController _noteController = TextEditingController();

  // void createOrderItems(CoffeeQuantityProvider coffeeQuantityProvider) {
  //   orderItems = widget.items.map((coffee) {
  //     final quantity = coffeeQuantityProvider.getQuantity(coffee);
  //     // Tạo đối tượng OrderItem với id và quantity
  //     return OrderItem(
  //       quantity: quantity, // Gán số lượng
  //       coffee: coffee, // Gán id của cà phê
  //     );
  //   }).toList();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   String initialNote = widget.coffeesData.map((coffee) {
  //     return '${coffee.coffeeName} - ${coffee.size}';
  //   }).join('\n');
  //   note = initialNote;
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<CoffeeQuantityProvider>(context, listen: false)
  //         .initialize(widget.coffeesData);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    final paymentViewModel =
        Provider.of<PaymentViewModel>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sử dụng AddressSection
              AddressSection(
                selectedAddress: _selectedAddress,
                onAddressSelected: (Address? address) {
                  setState(() {
                    _selectedAddress = address;
                  });
                },
                onNoteUpdated: (String newNote) {
                  setState(() {
                    note = newNote;
                  });
                },
                note: note,
                noteController: _noteController,
              ),
              const SizedBox(height: 15),
              Divider(
                color: Colors.grey.shade300,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 15),
              // Sử dụng CoffeeListSection
              CoffeeListSection(cartItems: widget.items),
              const SizedBox(height: 20),
              Divider(
                color: Colors.grey.shade300,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              // Sử dụng VoucherSection
              VoucherSection(
                initiallySelectedVouchers: selectedVouchers,
                onVouchersSelected: (vouchers) {
                  setState(() {
                    selectedVouchers = vouchers;
                    voucherCode = vouchers
                        .map((voucher) => voucher.code)
                        .whereType<String>()
                        .toList();
                  });
                },
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  paymentViewModel.selectAndProcessPaymentMethod(
                      context); // Gọi hàm chọn và xử lý phương thức thanh toán
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
                      // Sử dụng Consumer để cập nhật phương thức thanh toán
                      Consumer<PaymentViewModel>(
                        builder: (context, paymentViewModel, child) {
                          return Text(paymentViewModel.paymentMethod);
                        },
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sử dụng PaymentSummarySection
              PaymentSummarySection(selectedVouchers: selectedVouchers),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildPrice(authViewModel, orderViewModel),
    );
  }

  Widget buildPrice(
      AuthViewModel authViewModel, OrderViewModel orderViewModel) {
    double totalPrice = 0.0;
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
              Consumer<CoffeeQuantityProvider>(
                builder: (context, coffeeQuantityProvider, child) {
                  totalPrice = coffeeQuantityProvider
                      .calculateTotalPrice(selectedVouchers);
                  return Text(
                    NumberFormat.currency(
                      decimalDigits: 2,
                      locale: 'en_US',
                      symbol: '\$ ',
                    ).format(coffeeQuantityProvider
                        .calculateTotalPrice(selectedVouchers)),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffC67C4E),
                    ),
                  );
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffC67C4E), // Màu của nút
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Tạo bo tròn cho nút
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
          )
        ],
      ),
    );
  }
}
