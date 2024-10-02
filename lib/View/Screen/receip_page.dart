import 'package:coffee_shop/View/StateDeliverScreen/voucher_provider.dart';
import 'package:coffee_shop/ViewModel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderViewModel = Provider.of<OrderViewModel>(context);

    // Giả định rằng bạn có một danh sách sản phẩm trong orderViewModel
    final productList = orderViewModel.addItemResponse.data!.data!.orderItems;
    final typePrice = Provider.of<VoucherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hóa đơn'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Success Message
            Text(
              'Giao dịch của bạn đã thành công',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Transaction ID and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mã giao dịch', style: TextStyle(fontSize: 14)),
                Text(orderViewModel.addItemResponse.data!.data!.transactionCode.toString(), style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thời gian', style: TextStyle(fontSize: 14)),
                Text(orderViewModel.addItemResponse.data!.data!.orderDate.toString(), style: TextStyle(fontSize: 14)),
              ],
            ),
            Divider(),

            // Product List
            ...?productList?.map((product) => ProductItem(
              name: product.coffeeData!.coffeeName.toString(),
              price: product.coffeeData!.coffeePrice!.toDouble(),
              quantity: product.quantity!.toInt(),
              image: product.coffeeData!.coffeeImageUrl.toString(),
            )).toList(),

            Divider(),

            // Payment Summary
            SummaryItem(label: 'Giá', value: typePrice.originalPrice.toString()),
            SizedBox(height: 6),
            SummaryItem(label: 'Khuyến mại', value:typePrice.totalDiscount.toString()),
            SizedBox(height: 6),
            SummaryItem(label: 'Tổng tiền', value: typePrice.totalPriceAfterDiscount.toString(), isBold: true),

            SizedBox(height: 16),
            Text('Phương thức thanh toán', style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),
            Text(
              'Credit or debit card',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Divider(),

            // Delivery Information
            Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),
            SummaryItem(label: 'Họ và Tên', value: orderViewModel.addItemResponse.data!.data!.address!.name.toString()),
            SizedBox(height: 6),
            SummaryItem(label: 'Điện thoại', value: orderViewModel.addItemResponse.data!.data!.address!.phone.toString()),
            SizedBox(height: 6),
            SummaryItem(label: 'Địa chỉ', value: orderViewModel.addItemResponse.data!.data!.address!.address.toString()),

            // Button to track the order
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Thêm hành động theo dõi đơn hàng tại đây
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Theo dõi đơn hàng được nhấn!')),
                  );
                },
                child: Text('Theo dõi đơn hàng'),
              ),
            ),
          ],
        ),
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

  ProductItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Sử dụng Image.network để tải ảnh từ internet
          Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Đồ uống Đá, Giảm bớt Đường, Bình thường Đá', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Text('${price}vnd x $quantity', style: TextStyle(fontSize: 14)),
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

  SummaryItem({
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
          Text(label, style: TextStyle(fontSize: 14)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
