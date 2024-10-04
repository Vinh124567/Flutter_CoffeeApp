import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:coffee_shop/Repository/coffee_repository.dart';
import 'package:flutter/cupertino.dart';

import '../Model/Coffees/coffee_response.dart';
import '../Model/Coffees/review_request.dart';

class CoffeeViewModel with ChangeNotifier {
  final _myRepo = CoffeeRepository();

  ApiResponse<CoffeeResponse> coffeeList = ApiResponse.loading();
  ApiResponse<String> reviewResponse = ApiResponse.loading();

  setCoffeeList(ApiResponse<CoffeeResponse> response) {
    coffeeList = response;
    notifyListeners();
  }

  setReviewResponse(ApiResponse<String> response) {
    reviewResponse = response; // Cập nhật trạng thái phản hồi đánh giá
    notifyListeners();
  }

  Future<void> fetchCoffeeListApi() async {
    setCoffeeList(ApiResponse.loading());
    _myRepo.fetchCoffeeList().then((value) {
      print("Fetched coffee list successfully!");
      setCoffeeList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      print("Error occurred: $error"); // In ra lỗi
      setCoffeeList(ApiResponse.error(error.toString()));
    });
  }

  // Phương thức để thêm đánh giá
  Future<void> addReview(int coffeeId, String userId, int rating, String reviewText) async {
    setReviewResponse(ApiResponse.loading());
    ReviewDTO reviewRequest = ReviewDTO(rating: rating, reviewText: reviewText,coffeeId: coffeeId,userId: userId); // Tạo ReviewDTO
    _myRepo.newReview(reviewRequest).then((response) {
      print("Review added successfully!");
      setReviewResponse(ApiResponse.completed("Đánh giá đã được thêm!"));
    }).onError((error, stackTrace) {
      print("Error occurred while adding review: $error");
      setReviewResponse(ApiResponse.error(error.toString()));
    });
  }
}
