import '../Coffees/coffee_response.dart';

class CartResponse {
  int? status;
  CartItem? data;
  CartResponse({this.status, this.data});

  CartResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new CartItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CartItem {
  int? id;
  String? userId;
  List<CartItemData>? cartItems;

  CartItem({this.id, this.userId, this.cartItems});

  CartItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    if (json['cartItems'] != null) {
      cartItems = <CartItemData>[];
      json['cartItems'].forEach((v) {
        cartItems!.add(new CartItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    if (this.cartItems != null) {
      data['cartItems'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemData {
  int? id;
  String? size;
  CoffeeData? coffeeData;
  int? quantity;

  CartItemData({this.id, this.size, this.coffeeData,this.quantity});

  CartItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
    quantity=json['quantity'];
    coffeeData = json['coffeeResponseDTO'] != null
        ? new CoffeeData.fromJson(json['coffeeResponseDTO'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['quantity']=this.quantity;
    if (this.coffeeData != null) {
      data['coffeeResponseDTO'] = this.coffeeData!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'CartItemData{id: $id, size: $size, coffeeData: $coffeeData, quantity: $quantity}';
  }
}
