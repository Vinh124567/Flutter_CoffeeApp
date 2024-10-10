class CartItemCreateDTO {
 String? userId;
 int? coffeeId;
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
