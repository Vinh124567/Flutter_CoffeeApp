
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/coffee_dto.dart';
import '../../../Model/order_dto.dart';
import '../../../Model/voucher_dto.dart';
import '../../../Model/address_dto.dart';
import '../../../ViewModel/auth_view_model.dart';
import '../../../ViewModel/payment_view_model.dart';
import '../../../routes/route_name.dart';
import '../../StateDeliverScreen/CoffeeQuantityProvider.dart';

class Deliver extends StatefulWidget {
  final List<Coffee> coffees;

  const Deliver({super.key, required this.coffees});

  @override
  _DeliverState createState() => _DeliverState();
}

class _DeliverState extends State<Deliver> {
  OrderDTO? orderDTO;
  List<Voucher> selectedVouchers = []; // Danh sách voucher đã chọn
  Address? _selectedAddress; // Địa chỉ đã chọn từ màn hình Address
  String note = ''; // Biến lưu trữ ghi chú
  List<OrderItem> orderItems = [];
  List<String> voucherCode = [];
  final TextEditingController _noteController = TextEditingController();

  void createOrderItems(CoffeeQuantityProvider coffeeQuantityProvider) {
    orderItems = widget.coffees.map((coffee) {
      final quantity = coffeeQuantityProvider.getQuantity(coffee);

      // Tạo đối tượng OrderItem với id và quantity
      return OrderItem(
        quantity: quantity, // Gán id của cà phê
        coffeeId: coffee.id??0, // Gán số lượng// Gán giá tiền từ coffee object (nếu có)
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    String initialNote = widget.coffees.map((coffee) {
      return '${coffee.name} - ${coffee.size}';
    }).join('\n');
    note = initialNote;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CoffeeQuantityProvider>(context, listen: false)
        .initialize(widget.coffees);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final paymentViewModel = Provider.of<PaymentViewModel>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Deliver Address",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 13),
              const Text("Customer's address"),
              const SizedBox(height: 10),
              _selectedAddress == null
                  ? const Text("No address selected")
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${_selectedAddress!.name ?? 'Unknown'}"),
                        Text("Phone: ${_selectedAddress!.phone ?? 'Unknown'}"),
                        Text(
                            "Address: ${_selectedAddress!.address ?? 'Unknown'}"),
                      ],
                    ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          RouteName.address,
                          arguments: _selectedAddress,
                        ) as Address?;

                        if (result != null) {
                          setState(() {
                            _selectedAddress = result;
                          });
                        }
                      },
                      child: Container(
                        height: 25,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, size: 20, color: Colors.black),
                            SizedBox(width: 5),
                            Text("Edit address",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Gán thông tin cà phê mặc định nếu note chưa có nội dung
                            String initialText = widget.coffees.map((coffee) {
                              return '${coffee.name} - ${coffee.size}';
                            }).join('\n');

                            // Nếu note đã có nội dung, hiển thị lại nội dung này
                            _noteController.text = note.isNotEmpty ? note : initialText;

                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text(
                                'Thêm Ghi Chú',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _noteController,
                                        maxLines: 6,
                                        decoration: InputDecoration(
                                          labelText: 'Cà phê và Ghi chú',
                                          labelStyle: const TextStyle(fontSize: 14),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: const BorderSide(width: 0.5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Color(0xffC67C4E), width: 0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Hủy',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      // Lưu lại nội dung của TextField vào biến note
                                      note = _noteController.text;
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  child: const Text('Lưu'),
                                ),
                              ],
                            );
                          },
                        );

                      },


                      child: Container(
                        height: 25,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black),
                          color: Colors.white,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_note_outlined,
                                size: 20, color: Colors.black),
                            SizedBox(width: 5),
                            Text("Note", style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(
                color: Colors.grey.shade300,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 15),
              // Hiển thị thông tin các sản phẩm đã chọn
              Consumer<CoffeeQuantityProvider>(
                  builder: (context, coffeeQuantityProvider, child) {
                return Column(
                  children: widget.coffees.map((coffee) {
                    final quantity = coffeeQuantityProvider.getQuantity(coffee);
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            coffee.imageUrl.toString(),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(coffee.name ?? "Unknown Coffee"),
                              const Text("Deep Foam"),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            coffeeQuantityProvider.increaseQuantity(coffee);
                          },
                          label: const Icon(Icons.add),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            minimumSize: const Size(10, 10),
                          ),
                        ),
                        Text(quantity.toString()),
                        // Hiển thị số lượng hiện tại
                        ElevatedButton.icon(
                          onPressed: () {
                            coffeeQuantityProvider.decreaseQuantity(coffee);
                          },
                          label: const Icon(Icons.remove),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            minimumSize: const Size(10, 10),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }),
              const SizedBox(height: 20),
              Divider(
                color: Colors.grey.shade300,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    RouteName.voucher,
                    arguments: selectedVouchers,
                  ) as List<Voucher>?;

                  if (result != null) {
                    setState(() {
                      selectedVouchers = result;
                      voucherCode = result.map((voucher) => voucher.code).whereType<String>().toList();
                    });
                  }
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
                      const Icon(Icons.discount, size: 20),
                      Text(
                        "Discount is Applied (${selectedVouchers.length} selected)",
                        style: const TextStyle(color: Colors.black),
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  paymentViewModel.selectAndProcessPaymentMethod(context);  // Gọi hàm chọn và xử lý phương thức thanh toán
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
                          return Text(paymentViewModel.paymentMethod);  // Hiển thị phương thức thanh toán đã chọn
                        },
                      ),
                      const Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text("Payment Summary", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Consumer<CoffeeQuantityProvider>(
                  builder: (context, coffeeQuantityProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Price: "),
                    Text(
                      NumberFormat.currency(
                        decimalDigits: 2,
                        locale: 'en_US',
                        symbol: '\$ ',
                      ).format(getTotalPrice(coffeeQuantityProvider)),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffC67C4E),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 10),

              Consumer<CoffeeQuantityProvider>(
                  builder: (context, coffeeQuantityProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Price after Discount: "),
                    Text(
                      NumberFormat.currency(
                        decimalDigits: 2,
                        locale: 'en_US',
                        symbol: '\$ ',
                      ).format(calculateTotalPrice(coffeeQuantityProvider)),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Color(0xffC67C4E),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildPrice(authViewModel),
    );
  }

  Widget buildPrice(AuthViewModel authViewModel) {
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
                  totalPrice = calculateTotalPrice(coffeeQuantityProvider);
                  return Text(
                    NumberFormat.currency(
                      decimalDigits: 2,
                      locale: 'en_US',
                      symbol: '\$ ',
                    ).format(calculateTotalPrice(coffeeQuantityProvider)),
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
            onPressed: () {
              String userId = authViewModel.user?.uid ?? "defaultUserId"; // Gán giá trị mặc định nếu userId là null
              int addressId = _selectedAddress?.id ?? 0; // Gán 0 nếu addressId là null
              final coffeeQuantityProvider = Provider.of<CoffeeQuantityProvider>(context, listen: false);
              createOrderItems(coffeeQuantityProvider);

              // Tạo OrderDTO
              orderDTO = OrderDTO(
                userId: userId,
                totalPrice: totalPrice,
                notes: note,
                status: OrderStatus.PENDING,
                orderItems: orderItems,
                voucherCodes: voucherCode,
                addressId: addressId,
              );

              print(orderDTO);
            },

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
          ),
        ],
      ),
    );
  }



  double getTotalPrice(CoffeeQuantityProvider coffeeQuantityProvider) {
    return widget.coffees.fold(0, (sum, coffee) {
      final quantity = coffeeQuantityProvider.getQuantity(coffee);
      return sum + (coffee.price ?? 0) * quantity;
    });
  }
  double calculateTotalPrice(CoffeeQuantityProvider coffeeQuantityProvider) {
    double totalPrice = getTotalPrice(coffeeQuantityProvider);

    // Tính tổng tỷ lệ giảm giá từ các voucher
    double totalDiscountPercentage = selectedVouchers.fold(0, (sum, voucher) {
      // Giả sử voucher.discount là tỷ lệ phần trăm giảm giá, ví dụ: 10.0 cho 10%
      return sum + (voucher.discount ?? 0);
    });

    // Tính tổng giá sau khi áp dụng giảm giá
    double discountedPrice = totalPrice * (1 - totalDiscountPercentage / 100);

    return discountedPrice;
  }
}
