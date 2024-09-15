import 'package:coffee_shop/ViewModel/cartitem_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Data/Response/status.dart';
import '../../Model/coffee_dto.dart';
import '../../ViewModel/auth_view_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartItemViewModel =
          Provider.of<CartItemViewModel>(context, listen: false);
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      cartItemViewModel
          .fetchCartItemListApi(authViewModel.user!.uid.toString());
    });
  }

  double calculateTotalPrice(List<Coffee> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + (item.price!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Consumer<CartItemViewModel>(
        builder: (context, cartItemViewModel, child) {
          switch (cartItemViewModel.cartItemList.status) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());
            case Status.ERROR:
              return Center(
                child: Text(
                    cartItemViewModel.cartItemList.message ?? 'Đã xảy ra lỗi.'),
              );
            case Status.COMPLETED:
              final cartItemList = cartItemViewModel.cartItemList.data?.data;
              if (cartItemList == null || cartItemList.isEmpty) {
                return const Center(child: Text('Giỏ hàng trống.'));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItemList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.network(
                              cartItemList[index].imageUrl != null &&
                                      cartItemList[index].imageUrl!.isNotEmpty
                                  ? cartItemList[index].imageUrl!
                                  : 'https://via.placeholder.com/50',
                              // URL ảnh mặc định
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/bean.png',
                                  // Ảnh mặc định nếu URL không hợp lệ
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            title: Text(cartItemList[index].name.toString()),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Giá: \$${cartItemList[index].price}'),
                                // Dòng giá
                                const SizedBox(height: 4),
                                // Khoảng cách giữa các dòng
                                Text("Size: M"),
                                // Dòng thứ nhất
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Tổng tiền: \$${calculateTotalPrice(cartItemList).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Thanh toán thành công!')),
                        );
                      },
                      child: const Text('Thanh toán'),
                    ),
                  ),
                ],
              );
            default:
              return const Center(child: Text('Unknown error occurred'));
          }
        },
      ),
    );
  }
}
