import 'package:coffee_shop/Model/Order/order_create_request.dart';
import 'package:coffee_shop/Model/Order/order_response.dart';
import 'package:coffee_shop/Repository/order_repository.dart';
import 'package:flutter/cupertino.dart';
import '../Data/Response/api_response.dart';

class OrderViewModel with ChangeNotifier {
  final _myRepo = OrderRepository();

  ApiResponse<OrderResponse> addItemResponse = ApiResponse.loading();

  // Hàm cập nhật phản hồi đơn hàng
  void setNewOrderResponse(ApiResponse<OrderResponse> response) {
    addItemResponse = response;
    notifyListeners();
  }

  // Hàm gọi API để tạo đơn hàng mới
  Future<ApiResponse<String>> newOrderApi(OrderCreateRequest request) async {
    setNewOrderResponse(ApiResponse.loading()); // Đặt trạng thái là loading
    try {
      OrderResponse response = await _myRepo.newOrder(request); // Gọi hàm từ repository
      print("Order response: $response"); // In ra phản hồi từ API

      setNewOrderResponse(ApiResponse.completed(response)); // Cập nhật thành công
      return ApiResponse.completed("Success"); // Trả về thành công
    } catch (error, stackTrace) {
      print("Error creating order: $error"); // In ra lỗi nếu có
      setNewOrderResponse(ApiResponse.error(error.toString())); // Cập nhật lỗi
      return ApiResponse.error(error.toString()); // Trả về lỗi
    }
  }
}

