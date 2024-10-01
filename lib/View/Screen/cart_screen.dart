

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Data/Response/status.dart';
import '../../Model/Cart/cart_response.dart';
import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/cartitem_view_model.dart';
import '../../routes/route_name.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Consumer<CartItemViewModel>(
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
                  Expanded(
                    child: CartItemWidget(
                      cartItemData: cartItems,
                      onToggleSelection: toggleSelection,
                      selectedItems: selectedItems,
                    ),
                  ),
                  CartActionButton(
                    onPressed: () {
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
                    totalAmount: totalAmount,
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

class CartItemWidget extends StatelessWidget {
  final List<CartItemData> cartItemData;
  final Function(CartItemData) onToggleSelection; // Tham số để toggle selection
  final List<CartItemData> selectedItems; // Danh sách các item đã chọn

  const CartItemWidget({
    Key? key,
    required this.cartItemData,
    required this.onToggleSelection,
    required this.selectedItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cartItemData.length,
      itemBuilder: (context, index) {
        final coffeeItem = cartItemData[index];

        return Dismissible(
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
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    coffeeItem.coffeeData!.coffeeImageUrl.toString(),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(coffeeItem.coffeeData!.coffeeName.toString()),
                subtitle: Text("Price: ${(coffeeItem.coffeeData?.coffeePrice ?? 0) * (coffeeItem.quantity ?? 0)}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: selectedItems.contains(coffeeItem), // Kiểm tra xem item có được chọn không
                      onChanged: (value) {
                        onToggleSelection(coffeeItem); // Gọi hàm toggle selection
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<CartItemViewModel>(context, listen: false).decreaseQuantity(coffeeItem);
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(coffeeItem.quantity.toString()),
                    IconButton(
                      onPressed: () {
                        Provider.of<CartItemViewModel>(context, listen: false).increaseQuantity(coffeeItem);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CartActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double totalAmount;

  const CartActionButton({
    Key? key,
    required this.onPressed,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text('Thanh toán: \$${totalAmount.toStringAsFixed(2)}'),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Data/Response/status.dart';
// import '../../Model/Cart/cart_response.dart';
// import '../../ViewModel/auth_view_model.dart';
// import '../../ViewModel/cartitem_view_model.dart';
// import '../../routes/route_name.dart';
//
// class CartPage extends StatefulWidget {
//   const CartPage({Key? key}) : super(key: key);
//
//   @override
//   _CartPageState createState() => _CartPageState();
// }
//
// class _CartPageState extends State<CartPage> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final cartItemViewModel = Provider.of<CartItemViewModel>(context, listen: false);
//       final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
//       cartItemViewModel.fetchCartItemListApi(authViewModel.user!.uid.toString());
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Giỏ hàng')),
//       body: Consumer<CartItemViewModel>(
//         builder: (context, cartItemViewModel, child) {
//           switch (cartItemViewModel.cartItemResponse.status) {
//             case Status.LOADING:
//               return const Center(child: CircularProgressIndicator());
//             case Status.ERROR:
//               return Center(
//                   child: Text(cartItemViewModel.cartItemResponse.message ??
//                       'Đã xảy ra lỗi.'));
//             case Status.COMPLETED:
//               final cartItems = cartItemViewModel.cartItemResponse.data?.data?.cartItems;
//               if (cartItems == null || cartItems.isEmpty) {
//                 return const Center(child: Text('Giỏ hàng trống.'));
//               }
//               double totalAmount = calculateTotal(cartItems);
//               return Column(
//                 children: [
//                   Expanded(
//                     child: CartItemWidget(cartItemData: cartItems),
//                   ),
//                   CartActionButton(onPressed: () {
//                     Navigator.pushNamed(context, RouteName.order,
//                         arguments: cartItemViewModel.cartItemResponse.data?.data?.cartItems);
//                   },totalAmount: totalAmount,),
//                 ],
//               );
//             default:
//               return const Center(child: Text('Unknown error occurred'));
//           }
//         },
//       ),
//     );
//   }
// }
//
// class CartItemWidget extends StatelessWidget {
//   final List<CartItemData> cartItemData;
//
//   const CartItemWidget({Key? key, required this.cartItemData}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: cartItemData.length,
//       itemBuilder: (context, index) {
//         final coffeeItem = cartItemData[index];
//
//         return Dismissible(
//           key: UniqueKey(),
//           background: Container(
//             color: Colors.redAccent,
//             child: Icon(
//               Icons.delete,
//               color: Colors.white,
//               size: 40,
//             ),
//             alignment: Alignment.centerRight,
//             padding: EdgeInsets.only(right: 20),
//             margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
//           ),
//           direction: DismissDirection.endToStart,
//           onDismissed: (direction) {
//             final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
//             Provider.of<CartItemViewModel>(context, listen: false)
//                 .removeItemFromCart(coffeeItem.id, authViewModel.user!.uid);
//             },
//           child: Card(
//             margin: EdgeInsets.all(8),
//             child: Padding(
//               padding: EdgeInsets.all(8),
//               child: ListTile(
//                 leading: CircleAvatar(
//                   radius: 30,
//                   backgroundImage: NetworkImage(
//                     coffeeItem.coffeeData!.coffeeImageUrl.toString(),
//                   ),
//                   backgroundColor: Colors.transparent,
//                 ),
//                 title: Text(coffeeItem.coffeeData!.coffeeName.toString()),
//                 subtitle: Text("Price: ${(coffeeItem.coffeeData?.coffeePrice ?? 0) * (coffeeItem.quantity ?? 0)}"),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         // Gọi phương thức decreaseQuantity từ CartItemViewModel
//                         Provider.of<CartItemViewModel>(context, listen: false).decreaseQuantity(coffeeItem);
//                       },
//                       icon: Icon(Icons.remove),
//                     ),
//                     Text(coffeeItem.quantity.toString()),
//                     IconButton(
//                       onPressed: () {
//                         // Gọi phương thức increaseQuantity từ CartItemViewModel
//                         Provider.of<CartItemViewModel>(context, listen: false).increaseQuantity(coffeeItem);
//                       },
//                       icon: Icon(Icons.add),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
// class CartActionButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final double totalAmount;
//   const CartActionButton({Key? key, required this.onPressed, required this.totalAmount}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         child: Text('Thanh toán: \$${totalAmount.toStringAsFixed(2)}'),
//       ),
//     );
//   }
// }
// double calculateTotal(List<CartItemData> cartItems) {
//   double total = 0.0;
//   for (var item in cartItems) {
//     total += (item.coffeeData?.coffeePrice ?? 0) * (item.quantity ?? 0);
//   }
//   return total;
// }
