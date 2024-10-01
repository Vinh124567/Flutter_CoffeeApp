import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/View/Screen/order_screen.dart';
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/order_dto.dart';
import '../Res/app_url.dart';

class OrderRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future newOrder(OrderDTO orderDTO) async {
    try {
      String url = AppUrl.createOrderUrl();
      dynamic jsonResponse = await _apiService.getPostApiResponse(
        url,
        orderDTO.toJson(), // Đảm bảo orderDTO.toJson() trả về Map<String, dynamic>
      );
      return jsonResponse; // Có thể trả về jsonResponse nếu bạn muốn nhận phản hồi từ API
    } catch (e) {
      print("Error creating order: ${e.toString()}");
      rethrow; // Rethrow để giữ nguyên stack trace khi có lỗi xảy ra
    }
  }


}
