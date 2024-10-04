
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/Coffees/coffee_response.dart';
import '../Model/Coffees/review_request.dart';
import '../Res/app_url.dart';

class CoffeeRepository{

  final BaseApiService _apiService= NetworkApiService();

  Future<CoffeeResponse> fetchCoffeeList() async{
    try{
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.getCoffeeUrl);
      CoffeeResponse coffeeList = CoffeeResponse.fromJson(jsonResponse);
      return coffeeList;
    }catch(e){
      rethrow;
    }
  }

  Future<ReviewDTO> newReview(ReviewDTO reviewRequest) async {
    try {
      String url = AppUrl.newReviewUrl; // URL để gửi yêu cầu tạo đánh giá
      dynamic jsonResponse = await _apiService.getPostApiResponse(
        url,
        reviewRequest.toJson(), // Chuyển đổi ReviewDTO thành JSON
      );
      return ReviewDTO.fromJson(jsonResponse);
    } catch (e) {
      print("Error creating review: ${e.toString()}"); // Thông báo lỗi
      rethrow; // Rethrow để giữ nguyên stack trace khi có lỗi xảy ra
    }
  }



}