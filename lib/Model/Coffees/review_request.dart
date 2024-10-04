class ReviewDTO {
  String? userId;
  int? coffeeId;
  int? rating;
  String? reviewText;

  ReviewDTO({this.userId, this.coffeeId, this.rating, this.reviewText});

  ReviewDTO.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    coffeeId = json['coffeeId'];
    rating = json['rating'];
    reviewText = json['reviewText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['coffeeId'] = this.coffeeId;
    data['rating'] = this.rating;
    data['reviewText'] = this.reviewText;
    return data;
  }
}