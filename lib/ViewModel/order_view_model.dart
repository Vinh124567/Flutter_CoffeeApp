import 'package:coffee_shop/Model/order_dto.dart';

import 'package:coffee_shop/Repository/order_repository.dart';
import 'package:flutter/cupertino.dart';
import '../Data/Response/api_response.dart';

class OrderViewModel with ChangeNotifier {
  final _myRepo = OrderRepository();

  ApiResponse<String> addItemResponse = ApiResponse.loading();

  setNewOrderResponse(ApiResponse<String> response) {
    addItemResponse = response;
    notifyListeners();
  }

  Future<ApiResponse<String>> newOrderApi(OrderDTO orderDTO) async {
    setNewOrderResponse(ApiResponse.loading());
    try {
      final jsonResponse = await _myRepo.newOrder(orderDTO);
      final status = jsonResponse['status'];
      final message = jsonResponse['message'];

      if (status == 200) {
        return ApiResponse.completed(message); // Thành công
      } else {
        return ApiResponse.error(message); // Thất bại
      }
    } catch (error, stackTrace) {
      print('Lỗi khi thêm item vào giỏ hàng: $error');
      print('Stacktrace: $stackTrace');
      return ApiResponse.error(error.toString());
    }
  }
}
