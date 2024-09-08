
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Model/coffee_dto.dart';
import '../../../Model/voucher_dto.dart';
import '../../../routes/route_name.dart';
import '../button_primary.dart';

class Deliver extends StatefulWidget {
  final Coffee coffee;

  const Deliver({Key? key, required this.coffee}) : super(key: key);

  @override
  _DeliverState createState() => _DeliverState();
}

class _DeliverState extends State<Deliver> {
  List<Voucher> selectedVouchers = []; // Danh sách voucher đã chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            const Text("Detail"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.address,
                          arguments: selectedVouchers);
                    },
                    child: Container(
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.location_on,
                              size: 20, color: Colors.black),
                          SizedBox(width: 5),
                          Text("New address",
                              style: TextStyle(color: Colors.black)),
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
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.coffee.imgUrl.toString(),
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
                      Text(widget.coffee.name ?? "Unknown Coffee"),
                      const Text("Deep Foam"),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    label: Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), minimumSize: Size(10, 10))),
                Text("1"),
                ElevatedButton.icon(
                    onPressed: () {},
                    label: Icon(Icons.remove),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), minimumSize: Size(10, 10))),
              ],
            ),
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
                      "Discount is Applies (${selectedVouchers.length} selected)",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.payment, size: 20),
                  Text("Payment method"),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Payment Summary", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Price: "),
                Text(
                  NumberFormat.currency(
                    decimalDigits: 2,
                    locale: 'en_US',
                    symbol: '\$ ',
                  ).format(widget.coffee.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xffC67C4E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildPrice(),
    );
  }

  Widget buildPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 360,
            child: ButtonPrimary(
              title: 'Order',
              onTap: () {
                Navigator.pushNamed(context, RouteName.voucher,
                    arguments: selectedVouchers);
              },
            ),
          ),
        ],
      ),
    );
  }
}
