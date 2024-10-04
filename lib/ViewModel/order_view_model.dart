
import 'package:coffee_shop/Model/Enum/OrderStatus.dart';
import 'package:coffee_shop/Model/Order/order_create_request.dart';
import 'package:coffee_shop/Model/Order/order_response.dart';
import 'package:coffee_shop/Repository/order_repository.dart';
import 'package:flutter/cupertino.dart';
import '../Data/Response/api_response.dart';
import '../Model/Coffees/coffee_response.dart';

class OrderViewModel with ChangeNotifier {
  final _myRepo = OrderRepository();

  ApiResponse<OrderResponse> addItemResponse = ApiResponse.loading();
  ApiResponse<CoffeeResponse> coffeeNotReviewResponse = ApiResponse.loading();
  ApiResponse<List<OrderResponseData>> orderDataResponse =
  ApiResponse.loading();

  // Hàm cập nhật phản hồi đơn hàng
  void setNewOrderResponse(ApiResponse<OrderResponse> response) {
    addItemResponse = response;
    notifyListeners();
  }

  void setCoffeeNotReviewResponse(ApiResponse<CoffeeResponse> response) {
    coffeeNotReviewResponse = response;
    notifyListeners();
  }

  void setOrderDataResponse(ApiResponse<List<OrderResponseData>> response) {
    orderDataResponse = response;
    notifyListeners();
  }

  // Hàm gọi API để tạo đơn hàng mới
  Future<ApiResponse<String>> newOrderApi(OrderCreateRequest request) async {
    setNewOrderResponse(ApiResponse.loading());
    try {
      OrderResponse response = await _myRepo.newOrder(request);
      setNewOrderResponse(ApiResponse.completed(response));
      return ApiResponse.completed("Success");
    } catch (error, stackTrace) {
      print(
          "Error creating order: $error, $stackTrace"); // Thêm stackTrace để dễ debug
      setNewOrderResponse(ApiResponse.error(error.toString()));
      return ApiResponse.error(error.toString());
    }
  }

  // Hàm gọi API để lấy đơn hàng
  Future<ApiResponse<String>> getOrder(
      String userId, OrderStatus orderStatus) async {
    setOrderDataResponse(ApiResponse.loading());
    try {
      List<OrderResponseData> orderResponseDataList =
          await _myRepo.fetchOrderDataList(userId, orderStatus);
      setOrderDataResponse(ApiResponse.completed(orderResponseDataList));
      return ApiResponse.completed("Success");
    } catch (error, stackTrace) {
      print(
          "Error fetching orders: $error, $stackTrace"); // In stackTrace để dễ debug
      setOrderDataResponse(ApiResponse.error(error.toString()));
      return ApiResponse.error(error.toString());
    }
  }

  Future<ApiResponse<String>> updateOrderStatus(
      int orderId, OrderStatus orderStatus, String paymentStatus) async {
    try {
      await _myRepo.updateOrderStatus(orderId, orderStatus, paymentStatus);
      return ApiResponse.completed("Order status updated successfully");
    } catch (error, stackTrace) {
      // Ghi lại thông tin lỗi và stack trace để dễ dàng gỡ lỗi
      print("Error updating order status: $error\nStack Trace: $stackTrace");

      // Trả về phản hồi lỗi với thông điệp lỗi
      return ApiResponse.error(
          "Failed to update order status: ${error.toString()}");
    }
  }

  Future<void> getCoffeeNotReview(String userId) async {
    setCoffeeNotReviewResponse(ApiResponse.loading());
    _myRepo.fetchCofferNotReview(userId).then((value) {
      setCoffeeNotReviewResponse(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      print("Error occurred: $error"); // In ra lỗi
      setCoffeeNotReviewResponse(ApiResponse.error(error.toString()));
    });
  }
}
