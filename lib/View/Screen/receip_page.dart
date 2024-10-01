import 'package:flutter/material.dart';

class ReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 16), // Increased spacing

            // Transaction ID and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mã giao dịch', style: TextStyle(fontSize: 14)),
                Text('1713577280022', style: TextStyle(fontSize: 14)),
              ],
            ),
            SizedBox(height: 12), // Increased spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Thời gian', style: TextStyle(fontSize: 14)),
                Text('20-04-2024, 08:41 AM', style: TextStyle(fontSize: 14)),
              ],
            ),
            Divider(),

            // Product List
            ProductItem(
              name: 'Coffee Marshmallow',
              price: 30000,
              quantity: 2,
              image: 'assets/images/banner.png',
            ),

            Divider(),

            // Payment Summary
            SummaryItem(label: 'Giá', value: '140.000vnd'),
            SizedBox(height: 6), // Increased spacing
            SummaryItem(label: 'Khuyến mại', value: '-14.000vnd'),
            SizedBox(height: 6), // Increased spacing
            SummaryItem(label: 'Tổng tiền', value: '126.000vnd', isBold: true),

            SizedBox(height: 16), // Increased spacing
            Text('Phương thức thanh toán', style: TextStyle(fontSize: 14)),
            SizedBox(height: 16),
            Text(
              'Credit or debit card',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Divider(),

            // Delivery Information
            Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 14)),
            SizedBox(height: 16), // Increased spacing
            SummaryItem(label: 'Họ và Tên', value: 'Nguyen Thu Thuy'),
            SizedBox(height: 6), // Increased spacing
            SummaryItem(label: 'Điện thoại', value: '0986868686'),
            SizedBox(height: 6), // Increased spacing
            SummaryItem(label: 'Địa chỉ', value: 'Trung Kinh, Cau Giay, Ha Noi'),

            // Button to track the order
            SizedBox(height: 24), // Space before the button
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
  final int price;
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
          Image.asset(image, width: 50, height: 50),
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
