import 'address_dto.dart';
import 'Coffees/coffee_response.dart';

enum OrderStatus { PENDING, COMPLETED, CANCELLED }

class OrderItem {
  final CoffeeData coffee;
  final int quantity;

  OrderItem({
    required this.coffee,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'coffee': coffee,
    'quantity': quantity,
  };

  @override
  String toString() {
    return 'Coffee ID: $coffee, Quantity: $quantity';
  }
}

class OrderDTO {
  final String userId;
  final double totalPrice;
  final String? notes;
  final OrderStatus status;
  final List<OrderItem> orderItems;
  final List<String>? voucherCodes;
  final Address address;

  OrderDTO({
    required this.userId,
    required this.totalPrice,
    this.notes,
    required this.status,
    required this.orderItems,
    this.voucherCodes,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'totalPrice': totalPrice,
    'notes': notes,
    'status': status.name,  // Enum chuyển sang chuỗi
    'orderItems': orderItems.map((item) => item.toJson()).toList(),
    'voucherCodes': voucherCodes,
    'address': address,
  };

  @override
  String toString() {
    return 'OrderDTO{userId: $userId, totalPrice: $totalPrice, notes: $notes, status: $status, orderItems: $orderItems, voucherCodes: $voucherCodes, address: $address}';
  }
}
