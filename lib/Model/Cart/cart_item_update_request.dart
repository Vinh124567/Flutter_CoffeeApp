class CartItemUpdateDTO {
  final int id; // ID của mục trong giỏ hàng
  final int? quantity; // Số lượng mới (nếu có)
  // Các thuộc tính khác nếu cần

  CartItemUpdateDTO({required this.id, this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      // Các thuộc tính khác nếu cần
    };
  }
}
