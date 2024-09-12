import 'package:flutter/material.dart';

import '../../Model/cart_dto.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(name: 'Sản phẩm 1', price: 10.0, quantity: 1),
    CartItem(name: 'Sản phẩm 2', price: 20.0, quantity: 2),
    CartItem(name: 'Sản phẩm 3', price: 15.0, quantity: 1),
  ];

  // Tính tổng tiền
  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(cartItems[index].name),
                    subtitle: Text('Giá: \$${cartItems[index].price}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (cartItems[index].quantity > 1) {
                                cartItems[index].quantity--;
                              }
                            });
                          },
                        ),
                        Text('${cartItems[index].quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              cartItems[index].quantity++;
                            });
                          },
                        ),
                        // Nút xóa sản phẩm
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          },
                        ),
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
              'Tổng tiền: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Thêm xử lý khi bấm nút thanh toán
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thanh toán thành công!')),
                );
              },
              child: const Text('Thanh toán'),
            ),
          ),
        ],
      ),
    );
  }
}
