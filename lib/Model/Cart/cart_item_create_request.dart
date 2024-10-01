class CartItemCreateDTO {
 String? userId;
 int? coffeeId; // Thay Long bằng int vì Dart không có kiểu Long
 String? size;
 String? quantity;

 CartItemCreateDTO({
  this.userId,
  this.coffeeId,
  this.size,
  this.quantity,
 });

 // Phương thức chuyển đổi đối tượng thành Map
 Map<String, dynamic> toJson() {
  return {
   'userId': userId,
   'coffeeId': coffeeId,
   'size': size,
   'quantity': quantity,
  };
 }
}
