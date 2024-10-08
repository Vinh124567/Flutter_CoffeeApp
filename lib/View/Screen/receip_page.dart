import 'package:coffee_shop/View/Screen/home_screen.dart';
import 'package:coffee_shop/View/StateDeliverScreen/voucher_provider.dart';
import 'package:coffee_shop/ViewModel/order_view_model.dart';
import 'package:coffee_shop/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../Model/Cart/cart_response.dart';
import '../Widget/button_primary.dart';

class ReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);
    final voucherProvider = Provider.of<VoucherProvider>(context);
    final productList = orderViewModel.addItemResponse.data!.data!.orderItems;

    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(68),
                buildHeader(),
                const Gap(38),
                buildTransactionMessage(),
                const SizedBox(height: 36),
                buildTransactionInfo(orderViewModel),
                const Divider(),
                buildProductList(productList,orderViewModel),
                const Divider(),
                buildPaymentSummary(orderViewModel),
                const Divider(),
                buildPaymentMethod(),
                const Divider(),
                buildDeliveryInfo(orderViewModel),
              ],
            ),
          ),
          buildBottomNavigation(context,voucherProvider),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Hóa đơn'),
    );
  }

  Widget buildTransactionMessage() {
    return Center(
      child: const Text(
        'Giao dịch của bạn đã thành công',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green
        ),
      ),
    );

  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chi Tiết Hóa Đơn',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
      ],
    );
  }

  Widget buildTransactionInfo(OrderViewModel orderViewModel) {
    return Column(
      children: [
        buildInfoRow('Mã giao dịch', orderViewModel.addItemResponse.data!.data!.transactionCode.toString()),
        const SizedBox(height: 12),
        buildInfoRow('Thời gian', orderViewModel.addItemResponse.data!.data!.orderDate.toString()),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget buildProductList(List<CartItemData>? productList,OrderViewModel orderViewModel) {
    return Column(
      children: productList?.map((product) {
        return ProductItem(
          name: product.coffeeData!.coffeeName.toString(),
          price: product.coffeeData!.coffeePrice!.toDouble(),
          quantity: product.quantity!.toInt(),
          image: product.coffeeData!.coffeeImageUrl.toString(),
          note:orderViewModel.addItemResponse.data?.data!.notes??"Không có ghi chú"
        );
      }).toList() ?? [],
    );
  }

  Widget buildPaymentSummary(OrderViewModel orderViewModel) {
    return Column(
      children: [
        SummaryItem(label: 'Giá', value: orderViewModel.addItemResponse.data!.data!.totalPrice.toString()),
        const SizedBox(height: 6),
        SummaryItem(label: 'Khuyến mại', value: orderViewModel.addItemResponse.data!.data!.discountAmount.toString()),
        const SizedBox(height: 6),
        SummaryItem(label: 'Tổng tiền', value: orderViewModel.addItemResponse.data!.data!.totalAfterDiscount.toString()),
      ],
    );
  }

  Widget buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Phương thức thanh toán', style: TextStyle(fontSize: 14)),
        SizedBox(height: 16),
        Text(
          'Credit or debit card',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDeliveryInfo(OrderViewModel orderViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 16),
        SummaryItem(label: 'Họ và Tên', value: orderViewModel.addItemResponse.data!.data!.address!.name.toString()),
        const SizedBox(height: 6),
        SummaryItem(label: 'Điện thoại', value: orderViewModel.addItemResponse.data!.data!.address!.phone.toString()),
        const SizedBox(height: 6),
        SummaryItem(label: 'Địa chỉ', value: orderViewModel.addItemResponse.data!.data!.address!.address.toString()),
      ],
    );
  }

  Widget buildBottomNavigation(BuildContext context,VoucherProvider voucherProvider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ButtonPrimary(
              title: 'Quay lại trang chủ',
              onTap: () {
                voucherProvider.resetValues();
                Navigator.pushNamed(context,RouteName.home);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display product details
class ProductItem extends StatelessWidget {
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String note;
  const ProductItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Ghi chú: "+ note, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Text('${price}vnd x $quantity', style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// Widget to display summary information
class SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryItem({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
