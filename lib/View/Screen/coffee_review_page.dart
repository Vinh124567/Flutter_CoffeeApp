import 'package:coffee_shop/Model/Coffees/coffee_response.dart';
import 'package:coffee_shop/ViewModel/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import '../../Data/Response/status.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../routes/route_name.dart';

class CoffeeReviewPage extends StatefulWidget {
  const CoffeeReviewPage({Key? key}) : super(key: key);

  @override
  _DeliveredPageState createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<CoffeeReviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final orderViewModel = Provider.of<OrderViewModel>(context, listen: false);

      // Chờ đợi kết quả từ getOrder
      await orderViewModel.getCoffeeNotReview(authViewModel.user!.uid.toString());

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
                  switch (orderViewModel.coffeeNotReviewResponse.status) {
                    case Status.LOADING:
                      return const Center(child: CircularProgressIndicator());
                    case Status.ERROR:
                      return Center(
                          child: Text(orderViewModel.orderDataResponse.message ?? 'Đã xảy ra lỗi.'));
                    case Status.COMPLETED:
                      final List<CoffeeData>? coffeeDataItems = orderViewModel.coffeeNotReviewResponse.data?.coffeesData;
                      if (coffeeDataItems == null || coffeeDataItems.isEmpty) {
                        return const Center(child: Text('Không có sản phẩm nào cần đánh giá.'));
                      }
                      return Column(
                        children: [
                          buildCartItems(coffeeDataItems),
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

  Widget buildCartItems(List<CoffeeData> coffeeDataItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: coffeeDataItems.length,
      itemBuilder: (context, index) {
        final coffeeData = coffeeDataItems[index];
        return Column(
          children: [
            buildCartItem(coffeeData),
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

  Widget buildCartItem(CoffeeData coffeeData) {
    return GestureDetector(
      onTap: () {
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
                    coffeeData.coffeeImageUrl.toString(),
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
                        coffeeData.coffeeName.toString(),
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
                        coffeeData.category.toString(),
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
                            coffeeData.coffeePrice.toString(),
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
                            "Chào"
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
              child: Container(

                decoration: BoxDecoration(
                  color: Colors.white, // Màu nền của khung
                  borderRadius: BorderRadius.circular(8), // Bo góc cho khung
                  border: Border.all(color: Colors.green, width: 1), // Đường viền
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.rating_page,arguments: coffeeData.coffeeId);
                  },
                  child: const Text(
                    "Đánh giá",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
