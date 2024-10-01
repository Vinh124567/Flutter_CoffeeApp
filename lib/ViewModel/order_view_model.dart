import 'package:coffee_shop/Model/order_dto.dart';
import 'package:coffee_shop/Repository/order_repository.dart';
import 'package:flutter/cupertino.dart';
import '../Data/Response/api_response.dart';

class OrderViewModel with ChangeNotifier {
  final _myRepo = OrderRepository();

  ApiResponse<String> addItemResponse = ApiResponse.loading();

  // Hàm cập nhật phản hồi đơn hàng
  void setNewOrderResponse(ApiResponse<String> response) {
    addItemResponse = response;
    notifyListeners();
  }

  // Hàm gọi API để tạo đơn hàng mới
  Future<ApiResponse<String>> newOrderApi(OrderDTO orderDTO) async {
    setNewOrderResponse(ApiResponse.loading()); // Đặt trạng thái là loading
    try {
      await _myRepo.newOrder(orderDTO); // Gọi hàm từ repository
      setNewOrderResponse(ApiResponse.completed("Success")); // Cập nhật thành công
      return ApiResponse.completed("Success"); // Trả về thành công
    } catch (error, stackTrace) {
      setNewOrderResponse(ApiResponse.error(error.toString())); // Cập nhật lỗi
      return ApiResponse.error(error.toString()); // Trả về lỗi
    }
  }
}
