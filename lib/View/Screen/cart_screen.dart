import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/Response/status.dart';
import '../../Model/coffee_dto.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/cartitem_view_model.dart';
import '../../routes/route_name.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

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
      cartItemViewModel.fetchCartItemListApi(authViewModel.user!.uid.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Consumer<CartItemViewModel>(
        builder: (context, cartItemViewModel, child) {
          switch (cartItemViewModel.cartItemList.status) {
            case Status.LOADING:
              return const Center(child: CircularProgressIndicator());
            case Status.ERROR:
              return Center(child: Text(cartItemViewModel.cartItemList.message ?? 'Đã xảy ra lỗi.'));
            case Status.COMPLETED:
              final cartItems = cartItemViewModel.cartItemList.data?.data;
              if (cartItems == null || cartItems.isEmpty) {
                return const Center(child: Text('Giỏ hàng trống.'));
              }
              return Column(
                children: [
                  Expanded(child: CartItemList(cartItems: cartItems)),
                  CartSummary(cartItems: cartItems),
                  CartActionButton(onPressed: () {
                    Navigator.pushNamed(context,RouteName.order,arguments:cartItemViewModel.cartItemList.data?.data);
                  }),
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

class CartItemList extends StatelessWidget {
  final List<Coffee> cartItems;

  const CartItemList({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? item.imageUrl!
                  : 'https://via.placeholder.com/50',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/bean.png',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(item.name.toString()),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Giá: \$${item.price}'),
                const SizedBox(height: 4),
                 Text("Size:"+item.size.toString()),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                final cartItemViewModel = Provider.of<CartItemViewModel>(context, listen: false);
                cartItemViewModel.removeItemFromCart(item.cartItemId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} đã được xóa khỏi giỏ hàng.')),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CartSummary extends StatelessWidget {
  final List<Coffee> cartItems;

  const CartSummary({Key? key, required this.cartItems}) : super(key: key);

  double calculateTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + (item.price!));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Tổng tiền: \$${calculateTotalPrice().toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CartActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CartActionButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text('Thanh toán'),
      ),
    );
  }
}
