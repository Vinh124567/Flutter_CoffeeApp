import 'package:flutter/material.dart';
import '../../Model/Coffees/coffee_response.dart';
import '../../Model/voucher_dto.dart';

class CoffeeQuantityProvider with ChangeNotifier {
  List<CoffeeData> _coffees = [];
  final Map<CoffeeData, int> _quantities = {};
  List<CoffeeData> get coffees => _coffees;
  // Define the initialize method
  void initialize(List<CoffeeData> coffees) {
    _coffees = coffees;
    // Initialize quantities for each coffee to 0
    for (var coffee in coffees) {
      _quantities[coffee] = 1;
    }
    notifyListeners();
  }

  int getQuantity(CoffeeData coffee) {
    return _quantities[coffee] ?? 1;
  }

  void increaseQuantity(CoffeeData coffee) {
    if (_quantities.containsKey(coffee)) {
      _quantities[coffee] = (_quantities[coffee] ?? 1) + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(CoffeeData coffee) {
    if (_quantities.containsKey(coffee) && (_quantities[coffee] ?? 1) > 1) {
      _quantities[coffee] = (_quantities[coffee] ?? 1) - 1;
      notifyListeners();
    }
  }

  double getTotalPrice() {
    double total = 0.0;
    _quantities.forEach((coffee, quantity) {
      total += (coffee.coffeePrice ?? 0) * quantity;
    });
    return total;
  }

  double calculateTotalPrice(List<Voucher> selectedVouchers) {
    double total = getTotalPrice();
    double totalDiscountPercentage = getTotalDiscountPercentage(selectedVouchers);
    double discountedPrice = total * (1 - totalDiscountPercentage / 100);
    return discountedPrice;
  }

  double getTotalDiscountPercentage(List<Voucher> selectedVouchers) {
    // Tính tổng giảm giá phần trăm từ danh sách voucher đã chọn
    double totalDiscount = 0.0;
    for (var voucher in selectedVouchers) {
      totalDiscount += (voucher.discount ?? 0);
    }
    return totalDiscount;
  }

//   async {
//   String userId = authViewModel.user?.uid ??
//       "defaultUserId"; // Gán giá trị mặc định nếu userId là null
//   final coffeeQuantityProvider =
//   Provider.of<CoffeeQuantityProvider>(context, listen: false);
//   createOrderItems(coffeeQuantityProvider);
//   if (_selectedAddress == null) {
//   Utils.flushBarErrorMessage('Address has not been selected ',context);
//   return; // Ngừng thực hiện nếu không có địa chỉ
//   }
//   // Tạo OrderDTO
//   orderDTO = OrderDTO(
//   userId: userId,
//   totalPrice: totalPrice,
//   notes: note,
//   status: OrderStatus.PENDING,
//   orderItems: orderItems,
//   voucherCodes: voucherCode,
//   address: _selectedAddress!,
//   );
//
//   // Gọi API để tạo đơn hàng
//   await orderViewModel.newOrderApi(orderDTO!);
//
//   switch (orderViewModel.addItemResponse.status) {
//   case Status.LOADING:
//   ScaffoldMessenger.of(context).showSnackBar(
//   SnackBar(content: Text('Loading...')),
//   );
//   break;
//   case Status.COMPLETED:
//   Navigator.pushReplacementNamed(
//   context, '/orderSuccessScreen');
//   break;
//   case Status.ERROR:
//   ScaffoldMessenger.of(context).showSnackBar(
//   SnackBar(
//   content: Text(
//   'Order failed: ${orderViewModel.addItemResponse.message}')),
//   );
//   break;
//   default:
//   // Xử lý các trường hợp khác nếu cần
//   break;
//   }
// },
}
