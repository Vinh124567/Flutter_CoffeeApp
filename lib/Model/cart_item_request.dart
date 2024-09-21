class CartItemRequest {
  String? userId;
  int? coffeeId;
  String? size;

  CartItemRequest({this.userId, this.coffeeId, this.size});

  CartItemRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    coffeeId = json['coffeeId'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['coffeeId'] = this.coffeeId;
    data['size'] = this.size;
    return data;
  }
}