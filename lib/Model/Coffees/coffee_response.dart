class CoffeeResponse {
  int? httpStatus; // Trạng thái HTTP
  List<CoffeeData>? coffeesData; // Danh sách cà phê

  CoffeeResponse({this.httpStatus, this.coffeesData});

  CoffeeResponse.fromJson(Map<String, dynamic> json) {
    httpStatus = json['status'];
    if (json['data'] != null) {
      coffeesData = <CoffeeData>[];
      json['data'].forEach((v) {
        coffeesData!.add(CoffeeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.httpStatus;
    if (this.coffeesData != null) {
      data['data'] = this.coffeesData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoffeeData {
  int? coffeeId; // ID cà phê
  String? coffeeName; // Tên cà phê
  String? coffeeImageUrl; // URL hình ảnh cà phê
  double? coffeePrice; // Giá cà phê
  String? coffeeDescription; // Mô tả cà phê
  double? averageRating; // Đánh giá trung bình
  String? category; // Danh mục cà phê

  CoffeeData({
    this.coffeeId,
    this.coffeeName,
    this.coffeeImageUrl,
    this.coffeePrice,
    this.coffeeDescription,
    this.averageRating,
    this.category,
  });

  CoffeeData.fromJson(Map<String, dynamic> json) {
    coffeeId = json['id'];
    coffeeName = json['name'];
    coffeeImageUrl = json['imageUrl'];
    coffeePrice = json['price'];
    coffeeDescription = json['description'];
    averageRating = json['ratingAverage'];
    category = json['category']; // Thêm category vào từ JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.coffeeId;
    data['name'] = this.coffeeName;
    data['imageUrl'] = this.coffeeImageUrl;
    data['price'] = this.coffeePrice;
    data['description'] = this.coffeeDescription;
    data['ratingAverage'] = this.averageRating;
    data['category'] = this.category; // Thêm category vào JSON
    return data;
  }

  @override
  String toString() {
    return 'CoffeeData{coffeeId: $coffeeId, coffeeName: $coffeeName, coffeeImageUrl: $coffeeImageUrl, coffeePrice: $coffeePrice, coffeeDescription: $coffeeDescription, averageRating: $averageRating, category: $category}';
  }
}
