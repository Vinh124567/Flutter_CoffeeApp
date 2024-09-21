enum OrderStatus { PENDING, COMPLETED, CANCELLED }

class OrderItem {
  final int coffeeId;
  final int quantity;

  OrderItem({
    required this.coffeeId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'coffeeId': coffeeId,
    'quantity': quantity,
  };

  @override
  String toString() {
    return 'Coffee ID: $coffeeId, Quantity: $quantity';
  }
}

class OrderDTO {
  final String userId;
  final double totalPrice;
  final String? notes;
  final OrderStatus status;
  final List<OrderItem> orderItems;
  final List<String>? voucherCodes;
  final int addressId;

  OrderDTO({
    required this.userId,
    required this.totalPrice,
    this.notes,
    required this.status,
    required this.orderItems,
    this.voucherCodes,
    required this.addressId,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'totalPrice': totalPrice,
    'notes': notes,
    'status': status.name,  // Enum chuyển sang chuỗi
    'orderItems': orderItems.map((item) => item.toJson()).toList(),
    'voucherCodes': voucherCodes,
    'addressId': addressId,
  };

  @override
  String toString() {
    return 'OrderDTO{userId: $userId, totalPrice: $totalPrice, notes: $notes, status: $status, orderItems: $orderItems, voucherCodes: $voucherCodes, addressId: $addressId}';
  }
}
