import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/View/Screen/order_screen.dart';
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/Order/order_create_request.dart';
import '../Model/Order/order_response.dart';
import '../Res/app_url.dart';

class OrderRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future newOrder(OrderCreateRequest orderRequest) async {
    try {
      String url = AppUrl.createOrderUrl;
      dynamic jsonResponse = await _apiService.getPostApiResponse(
        url,
        orderRequest.toJson(),
      );
      return  OrderResponse.fromJson(jsonResponse);// Có thể trả về jsonResponse nếu bạn muốn nhận phản hồi từ API
    } catch (e) {
      print("Error creating order: ${e.toString()}");
      rethrow; // Rethrow để giữ nguyên stack trace khi có lỗi xảy ra
    }
  }


}
