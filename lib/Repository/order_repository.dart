
import 'dart:ffi';

import 'package:coffee_shop/Model/Enum/OrderStatus.dart';

import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/Coffees/coffee_response.dart';
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

  Future<List<OrderResponseData>> fetchOrderDataList(String userId, OrderStatus orderStatus) async {
    try {
      String url = AppUrl.getOrderUrl(userId, orderStatus.value);
      // Gọi API
      dynamic jsonResponse = await _apiService.getGetApiResponse(url);
      // Kiểm tra xem jsonResponse có phải là Map không
      if (jsonResponse is Map<String, dynamic>) {
        // Kiểm tra xem jsonResponse có chứa dữ liệu trong 'data' và 'data' có phải là List không
        if (jsonResponse['data'] is List) {
          return (jsonResponse['data'] as List)
              .map((orderJson) => OrderResponseData.fromJson(orderJson))
              .toList();
        } else {
          // Xử lý khi 'data' không phải là List
          print('Data is not a list');
          return [];
        }
      } else {
        print('Response is not a Map');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<void> updateOrderStatus(int orderId, OrderStatus orderStatus, String paymentStatus) async {
    try {
      String url = AppUrl.updateOrderStatusUrl(orderId, orderStatus.value, paymentStatus);

      // Tạo một Map để gửi dữ liệu, có thể bỏ qua requestData nếu không cần gửi trong body
      Map<String, dynamic> requestData = {
        'orderStatus': orderStatus.value,
        'paymentStatus': paymentStatus,
      };

      // Gọi API cập nhật trạng thái đơn hàng
      await _apiService.getPutApiResponse(url, requestData);
    } catch (e) {
      print("Error updating order status: ${e.toString()}");
      rethrow; // Rethrow để giữ nguyên stack trace khi có lỗi xảy ra
    }
  }

  Future<CoffeeResponse> fetchCofferNotReview(String userId) async{
    try{
      // Lấy dữ liệu từ API
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.coffeeNotReviewUrl(userId));
      CoffeeResponse coffeeList = CoffeeResponse.fromJson(jsonResponse);
      return coffeeList;
    }catch(e){
      rethrow;
    }
  }

}
