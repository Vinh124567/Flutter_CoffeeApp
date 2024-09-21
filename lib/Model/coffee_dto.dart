class CoffeeList {
  int? status;
  String? message;
  List<Coffee>? data;

  CoffeeList({this.status, this.message, this.data}); // Sửa `Status` thành `status`

  factory CoffeeList.fromJson(Map<String, dynamic> json) {
    return CoffeeList(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Coffee.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      // Sửa `Data` thành `Coffee` trong `toJson`
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'status: $status, message: $message, data: ${data?.map((e) => e.toString()).toList()}';
  }
}
class Coffee {
  int? id;
  String? name;
  String? imageUrl;
  double? price;
  String? description;
  double? ratingAverage;
  String? categoryName;
  int? cartItemId;
  String? size;

  Coffee({
    this.id,
    this.name,
    this.imageUrl,
    this.price,
    this.description,
    this.ratingAverage,
    this.categoryName,
    this.cartItemId,
    this.size
  });


  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      description: json['description'],
      ratingAverage: json['ratingAverage'],
      categoryName: json['categoryName'],
      cartItemId: json['cartItemId'],
            size: json['size']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['price'] = price;
    data['description'] = description;
    data['ratingAverage'] = ratingAverage;
    data['categoryName'] = categoryName;
    return data;
  }

  @override
  String toString() {
    return 'id: $id, name: $name, imgUrl: $imageUrl, price: $price, description: $description, ratingAverage: $ratingAverage, categoryName: $categoryName';
  }
}

