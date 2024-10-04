import 'dart:ffi';

import 'package:coffee_shop/Model/Order/order_response.dart';
import 'package:coffee_shop/View/Screen/receip_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../Data/Response/status.dart';
import '../../Model/Enum/OrderStatus.dart';
import '../../ViewModel/order_view_model.dart';
import '../Widget/button_primary.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderResponseData orderResponseData;

  const OrderDetailPage({super.key, required this.orderResponseData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          // Main Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(18),
                  buildHeader(context),
                  const Gap(38),
                  buildTransactionMessage(),
                  const SizedBox(height: 36),
                  buildTransactionInfo(orderResponseData),
                  const Divider(),
                  buildProductList(orderResponseData),
                  const Divider(),
                  buildPaymentSummary(orderResponseData),
                  const Divider(),
                  buildPaymentMethod(),
                  const Divider(),
                  buildDeliveryInfo(orderResponseData),
                  const Divider(),
                  buildCancelButton(context)
                ],
              ),
            ),
          ),
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

  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const ImageIcon(
            AssetImage('assets/images/ic_arrow_left.png'),
          ),
        ),
        const Text(
          'Chi Tiết Đơn Hàng',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const ImageIcon(
            AssetImage('assets/images/ic_heart_border.png'),
          ),
        ),
      ],
    );
  }

  Widget buildCancelButton(BuildContext context) {
    // Kiểm tra trạng thái của đơn hàng
    if (orderResponseData.status == 'PENDING') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
          children: [
            const Text(
              'Trạng thái: Đơn hàng đang chờ xử lý', // Nội dung trạng thái
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.green, // Màu chữ
              ),
              textAlign: TextAlign.center, // Căn giữa chữ
            ),
            const SizedBox(height: 10), // Khoảng cách giữa ô văn bản và nút
            ElevatedButton(
              onPressed: () {
                // Thực hiện hành động hủy đơn hàng ở đây
                _cancelOrder(context,orderResponseData.id??167);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Màu nền nút
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 7), // Padding
                shape: RoundedRectangleBorder( // Tạo hình dạng bo góc
                  borderRadius: BorderRadius.circular(20), // Bo góc nút
                ),
              ),
              child: const Text(
                'Hủy Đơn Hàng',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white), // Kiểu chữ gọn gàng hơn
              ),
            ),
          ],
        ),
      );
    } else {
      // Nếu không phải trạng thái 'PENDING', chỉ hiển thị trạng thái
      return Center(
        child: Text(
          'Trạng thái: ${orderResponseData.status}', // Hiển thị trạng thái
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black, // Màu chữ
          ),
        ),
      );
    }
  }




  Widget buildTransactionInfo(OrderResponseData orderResponseData) {
    return Column(
      children: [
        buildInfoRow('Mã giao dịch',
            orderResponseData.transactionCode
                .toString()),
        const SizedBox(height: 12),
        buildInfoRow('Thời gian',
        orderResponseData.orderDate.toString()),
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

  Widget buildProductList( OrderResponseData orderResponseData) {
    return Column(
      children: orderResponseData.orderItems?.map((product) {
        return ProductItem(
          name: product.coffeeData!.coffeeName.toString(),
          price: product.coffeeData!.coffeePrice!.toDouble(),
          quantity: product.quantity!.toInt(),
          image: product.coffeeData!.coffeeImageUrl.toString(),
          note: orderResponseData.notes??"Không có",
        );
      }).toList() ?? [],
    );
  }

  Widget buildPaymentSummary(OrderResponseData orderResponseData) {
    return Column(
      children: [
        SummaryItem(label: 'Giá', value: orderResponseData.totalPrice.toString()),
        const SizedBox(height: 6),
        SummaryItem(
            label: 'Khuyến mại', value: orderResponseData.discountAmount.toString()),
        const SizedBox(height: 6),
        SummaryItem(label: 'Tổng tiền',
            value: orderResponseData.totalAfterDiscount.toString(),
            isBold: true),
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

  Widget buildDeliveryInfo(OrderResponseData orderResponseData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Địa chỉ giao hàng', style: TextStyle(fontSize: 14)),
        const SizedBox(height: 16),
        SummaryItem(label: 'Họ và Tên',
            value: orderResponseData.address!.name
                .toString()),
        const SizedBox(height: 6),
        SummaryItem(label: 'Điện thoại',
            value: orderResponseData.address!.phone
                .toString()),
        const SizedBox(height: 6),
        SummaryItem(label: 'Địa chỉ',
            value: orderResponseData.address!.address
                .toString()),
      ],
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
          Text(value, style: TextStyle(fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
void _cancelOrder(BuildContext context, int orderId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Xác Nhận Hủy Đơn Hàng"),
        content: const Text("Bạn có chắc chắn muốn hủy đơn hàng này?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng popup
            },
            child: const Text("Không"),
          ),
          TextButton(
            onPressed: () {
              // Sử dụng Consumer để truy cập OrderViewModel
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Consumer<OrderViewModel>(
                    builder: (context, orderViewModel, child) {
                      return AlertDialog(
                        title: const Text("Đang hủy đơn hàng..."),
                        content: const CircularProgressIndicator(),
                      );
                    },
                  );
                },
              );

              // Gọi phương thức updateOrderStatus
              Provider.of<OrderViewModel>(context, listen: false)
                  .updateOrderStatus(orderId, OrderStatus.cancelled, 'PAID')
                  .then((response) {
                // Kiểm tra xem widget có còn đang hoạt động không
                if (context.mounted) {
                  Navigator.of(context).pop(); // Đóng popup tiến trình
                  if (response.status == Status.COMPLETED) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Đơn hàng đã bị hủy.")),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Hủy đơn hàng không thành công: ${response.message}")),
                    );
                  }
                }
              }).catchError((error) {
                // Kiểm tra xem widget có còn đang hoạt động không
                if (context.mounted) {
                  Navigator.of(context).pop(); // Đóng popup tiến trình
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi: ${error.toString()}")),
                  );
                }
              });

              // Đóng popup xác nhận
              Navigator.of(context).pop();
            },
            child: const Text("Có"),
          ),
        ],
      );
    },
  );
}


