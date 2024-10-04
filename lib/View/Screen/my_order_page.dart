import 'package:coffee_shop/Model/Enum/OrderStatus.dart';
import 'package:coffee_shop/Model/Order/order_response.dart';
import 'package:coffee_shop/ViewModel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../../Data/Response/status.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/cartitem_view_model.dart';
import '../../routes/route_name.dart';

class DeliveredPage extends StatefulWidget {
  final OrderStatus orderStatus;
  const DeliveredPage({Key? key, required this.orderStatus}) : super(key: key);

  @override
  _DeliveredPageState createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<DeliveredPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
      await orderViewModel.getOrder(authViewModel.user!.uid.toString(),widget.orderStatus);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const Gap(24),
              Consumer<OrderViewModel>(
                builder: (context, orderViewModel, child) {
                  switch (orderViewModel.orderDataResponse.status) {
                    case Status.LOADING:
                      return const Center(child: CircularProgressIndicator());
                    case Status.ERROR:
                      return Center(
                          child: Text(orderViewModel.orderDataResponse.message ?? 'Đã xảy ra lỗi.'));
                    case Status.COMPLETED:
                      final List<OrderResponseData>? orderDataItems = orderViewModel.orderDataResponse.data;
                      if (orderDataItems == null || orderDataItems.isEmpty) {
                        return const Center(child: Text('Không có đơn hàng nào.'));
                      }
                      return Column(
                        children: [
                          buildCartItems(orderDataItems),
                          const Gap(24),
                        ],
                      );
                    default:
                      return const Center(child: Text('Unknown error occurred'));
                  }
                },
              ),
              const Gap(80), // Dành khoảng trống cho nút bên dưới
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCartItems(List<OrderResponseData> orderResponseData) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orderResponseData.length,
      itemBuilder: (context, index) {
        final orderItemData = orderResponseData[index];
        return Column(
          children: [
            buildCartItem(orderItemData),
            const Divider(
              color: Color(0xffE3E3E3),
              height: 1,
              thickness: 1,
            ),
          ],
        );
      },
    );
  }

  Widget buildCartItem(OrderResponseData orderItemData) {
    return GestureDetector(
      onTap: () {
        // Xử lý sự kiện khi nhấn vào item
        // Bạn có thể chuyển hướng sang trang chi tiết đơn hàng
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    orderItemData.orderItems![0].coffeeData!.coffeeImageUrl.toString(),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderItemData.orderItems!
                            .map((item) => item.coffeeData!.coffeeName)
                            .join(', '),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff242424),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(14),
                      Text(
                        '${orderItemData.orderItems?.length} Đồ uống',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Color(0xffA2A2A2),
                        ),
                      ),
                      const Gap(4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tổng tiền ban đầu có gạch ngang
                          Text(
                            '${orderItemData.totalPrice}',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Color(0xffA2A2A2),
                              decoration: TextDecoration.lineThrough, // Gạch ngang tổng tiền ban đầu
                            ),
                          ),
                          const Gap(4), // Khoảng cách giữa hai dòng
                          // Tổng tiền sau giảm giá
                          Text(
                            '${orderItemData.totalAfterDiscount}',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: Color(0xff242424), // Màu chữ đậm hơn để nhấn mạnh
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.order_detail,arguments: orderItemData);
                },
                child: const Text(
                  "Xem đơn hàng",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
