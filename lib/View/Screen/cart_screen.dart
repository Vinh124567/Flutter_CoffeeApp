import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../Data/Response/status.dart';
import '../../Model/Cart/cart_response.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/cartitem_view_model.dart';
import '../../routes/route_name.dart';
import '../Widget/button_primary.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItemData> selectedItems = []; // Danh sách các item đã chọn

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartItemViewModel = Provider.of<CartItemViewModel>(context, listen: false);
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      cartItemViewModel.fetchCartItemListApi(authViewModel.user?.uid ?? '');
    });
  }

  // Hàm để tính tổng tiền cho các item đã chọn
  double calculateTotal(List<CartItemData> cartItems) {
    double total = 0.0;
    for (var item in selectedItems) {
      total += (item.coffeeData?.coffeePrice ?? 0) * (item.quantity ?? 0);
    }
    return total;
  }

  // Hàm để toggle trạng thái checkbox
  void toggleSelection(CartItemData item) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item); // Bỏ chọn item nếu đã được chọn
      } else {
        selectedItems.add(item); // Thêm item vào danh sách đã chọn
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final cartItemViewModel = Provider.of<CartItemViewModel>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const Gap(68),
              buildHeader(),
              const Gap(24),
              Consumer<CartItemViewModel>(
                builder: (context, cartItemViewModel, child) {
                  switch (cartItemViewModel.cartItemResponse.status) {
                    case Status.LOADING:
                      return const Center(child: CircularProgressIndicator());
                    case Status.ERROR:
                      return Center(
                          child: Text(cartItemViewModel.cartItemResponse.message ?? 'Đã xảy ra lỗi.'));
                    case Status.COMPLETED:
                      final cartItems = cartItemViewModel.cartItemResponse.data?.data?.cartItems;
                      if (cartItems == null || cartItems.isEmpty) {
                        return const Center(child: Text('Giỏ hàng trống.'));
                      }
                      double totalAmount = calculateTotal(cartItems);
                      return Column(
                        children: [
                          buildCartItems(cartItems),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Colors.white, // Màu nền cho phần nút
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<CartItemViewModel>(
                    builder: (context, cartItemViewModel, child) {
                      final cartItems = cartItemViewModel.cartItemResponse.data?.data?.cartItems;
                      double totalAmount = calculateTotal(cartItems ?? []);
                      return buildPrice(totalAmount);
                    },
                  ),
                  const Gap(16), // Khoảng cách giữa tổng giá và nút
                  ButtonPrimary(
                    title: 'Proceed to Checkout',
                    onTap: () {
                      // Thực hiện hành động thanh toán
                      if (selectedItems.isNotEmpty) {
                        Navigator.pushNamed(context, RouteName.order,
                            arguments: selectedItems); // Truyền danh sách các item đã chọn
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng chọn ít nhất một sản phẩm.')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Text(
          'Your Cart',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),

      ],
    );
  }

  Widget buildCartItems(List<CartItemData> cartItems) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final coffeeItem = cartItems[index];

        return Column(
          children: [
            Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.redAccent,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40,
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                Provider.of<CartItemViewModel>(context, listen: false)
                    .removeItemFromCart(coffeeItem.id, authViewModel.user!.uid);
              },
              child: buildCartItem(coffeeItem),
            ),
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

  Widget buildCartItem(CartItemData coffeeItem) {
    bool isSelected = selectedItems.contains(coffeeItem);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              toggleSelection(coffeeItem);
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              coffeeItem.coffeeData!.coffeeImageUrl.toString(),
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
                  coffeeItem.coffeeData!.coffeeName.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xff242424),
                  ),
                ),
                const Gap(4),
                Text(
                  'Size: ${coffeeItem.size}',
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xffA2A2A2),
                  ),
                ),
                const Gap(4),
                Text(
                  NumberFormat.currency(
                    decimalDigits: 2,
                    locale: 'en_US',
                    symbol: '\$ ',
                  ).format((coffeeItem.coffeeData?.coffeePrice ?? 0) * (coffeeItem.quantity ?? 0)),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xffC67C4E),
                  ),
                ),
                const Gap(8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Provider.of<CartItemViewModel>(context, listen: false)
                            .decreaseQuantity(coffeeItem);
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      coffeeItem.quantity.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Color(0xff242424),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<CartItemViewModel>(context, listen: false)
                            .increaseQuantity(coffeeItem);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPrice(double totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xff242424),
          ),
        ),
        Text(
          NumberFormat.currency(
            decimalDigits: 2,
            locale: 'en_US',
            symbol: '\$ ',
          ).format(totalAmount),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Color(0xffC67C4E),
          ),
        ),
      ],
    );
  }
}
