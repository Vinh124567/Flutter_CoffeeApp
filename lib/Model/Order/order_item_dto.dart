class OrderItemDTO {
  final int coffeeId;
  final int quantity;
  final String size;
  OrderItemDTO({
    required this.coffeeId,
    required this.quantity,
    required this.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'coffeeId': coffeeId,
      'quantity': quantity,
      'size': size,
    };
  }

  factory OrderItemDTO.fromJson(Map<String, dynamic> json) {
    return OrderItemDTO(
      coffeeId: json['coffeeId'],
      quantity: json['quantity'],
      size: json['size'],
    );
  }

  @override
  String toString() {
    return 'OrderItemDTO{coffeeId: $coffeeId, quantity: $quantity, size: $size}';
  }
}
