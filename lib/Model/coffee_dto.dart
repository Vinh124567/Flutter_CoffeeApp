class CoffeeList {
  int? status;
  String? message;
  List<Coffee>? data;

  CoffeeList({this.status, this.message, this.data}); // Sửa `Status` thành `status`

  factory CoffeeList.fromJson(Map<String, dynamic> json) {
    return CoffeeList(
      status: json['status'],
      message: json['message'],
      // Sửa `Data` thành `Coffee` và chuyển đổi JSON thành danh sách đối tượng `Coffee`
      data: json['data'] != null
          ? (json['data'] as List).map((i) => Coffee.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = this.status;
    data['message'] = this.message;
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
  String? imgUrl;
  double? price;
  String? description;
  double? ratingAverage;
  String? categoryName;

  Coffee({
    this.id,
    this.name,
    this.imgUrl,
    this.price,
    this.description,
    this.ratingAverage,
    this.categoryName,
  });

  // Sửa `Data.fromJson` thành `Coffee.fromJson` để khớp với tên lớp
  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'],
      name: json['name'],
      imgUrl: json['imgUrl'],
      price: json['price'],
      description: json['description'],
      ratingAverage: json['ratingAverage'],
      categoryName: json['categoryName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['imgUrl'] = this.imgUrl;
    data['price'] = this.price;
    data['description'] = this.description;
    data['ratingAverage'] = this.ratingAverage;
    data['categoryName'] = this.categoryName;
    return data;
  }

  @override
  String toString() {
    return 'id: $id, name: $name, imgUrl: $imgUrl, price: $price, description: $description, ratingAverage: $ratingAverage, categoryName: $categoryName';
  }
}
