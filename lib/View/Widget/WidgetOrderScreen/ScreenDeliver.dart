
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Model/coffee_dto.dart';
import '../../../Model/voucher_dto.dart';
import '../../../Model/address_dto.dart';
import '../../../routes/route_name.dart';
import '../../StateDeliverScreen/CoffeeQuantityProvider.dart';

class Deliver extends StatefulWidget {
  final List<Coffee> coffees;

  const Deliver({super.key, required this.coffees});

  @override
  _DeliverState createState() => _DeliverState();
}

class _DeliverState extends State<Deliver> {
  List<Voucher> selectedVouchers = []; // Danh sách voucher đã chọn
  Address? _selectedAddress; // Địa chỉ đã chọn từ màn hình Address

  @override
  void initState() {
    super.initState();
    // Initialize provider with coffee list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CoffeeQuantityProvider>(context, listen: false)
        .initialize(widget.coffees);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("buil");
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
                      onTap: () {
                        print('New address button pressed');
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
                            coffee.imgUrl.toString(),
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
              Container(
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.payment, size: 20),
                    Text("Payment method"),
                    Icon(Icons.arrow_forward_ios),
                  ],
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
      bottomNavigationBar: buildPrice(),
    );
  }

  Widget buildPrice() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(20),
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
          const Text(
            "Total",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Consumer<CoffeeQuantityProvider>(
              builder: (context, coffeeQuantityProvider, child) {
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
          }),
        ],
      ),
    );
  }

  // double getTotalPrice() {
  //   return widget.coffees.fold(0, (sum, coffee) {
  //     final quantity =
  //         Provider.of<CoffeeQuantityProvider>(context).getQuantity(coffee);
  //     return sum + (coffee.price ?? 0) * quantity;
  //   });
  // }
  //
  // double calculateTotalPrice() {
  //   // Calculate total price after applying discounts and vouchers
  //   // This is just an example calculation
  //   double totalPrice = getTotalPrice();
  //   double discount = selectedVouchers.fold(0, (sum, voucher) {
  //     return sum + (voucher.discount ?? 0);
  //   });
  //   return totalPrice - discount;
  // }

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



// double calculateTotalPrice(CoffeeQuantityProvider coffeeQuantityProvider) {
  //   double totalPrice = getTotalPrice(coffeeQuantityProvider);
  //
  //   // Kiểm tra các voucher có hợp lệ không trước khi áp dụng giảm giá
  //   double discount = selectedVouchers.fold(0, (sum, voucher) {
  //     DateTime now = DateTime.now();
  //
  //     // Chuyển đổi validFrom và validUntil thành DateTime
  //     DateTime? validFrom = voucher.validFrom != null
  //         ? DateTime.parse(voucher.validFrom!)
  //         : null;
  //     DateTime? validUntil = voucher.validUntil != null
  //         ? DateTime.parse(voucher.validUntil!)
  //         : null;
  //
  //     // Kiểm tra xem voucher có trong thời gian hợp lệ hay không
  //     if ((validFrom == null || validFrom.isBefore(now)) &&
  //         (validUntil == null || validUntil.isAfter(now))) {
  //       return sum + (voucher.discount ?? 0);
  //     }
  //
  //     return sum;
  //   });
  //
  //   return totalPrice - discount;
  // }


}
