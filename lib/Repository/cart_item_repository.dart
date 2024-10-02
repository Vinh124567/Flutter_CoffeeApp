
import 'package:coffee_shop/Model/Cart/cart_item_update_request.dart';

import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/Cart/cart_item_create_request.dart';
import '../Model/Cart/cart_response.dart';
import '../Res/app_url.dart';

class CartItemRepository{

  final BaseApiService _apiService= NetworkApiService();

  Future<CartResponse> fetchCartItemList(String userId) async{
    try{
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.cartItemUrl(userId));
      CartResponse coffeeResponse = CartResponse.fromJson(jsonResponse);
      return coffeeResponse;
    }catch(e){
      rethrow;
    }
  }

  // Phương thức thêm item vào giỏ hàng
  Future<Map<String, dynamic>> addItemToCart(CartItemCreateDTO request) async {
    try {
      String url = AppUrl.addItemCartUrl;
      dynamic jsonResponse = await _apiService.getPostApiResponse(
        url,
        request.toJson(),
      );
      return jsonResponse;
    } catch (e) {
      print("Error adding item to cart: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> deleteCartItem(int cartItemId) async {
    try {
      String url = AppUrl.deleteCartItemUrl(cartItemId); // Xây dựng URL cho xóa mục
      await _apiService.getDeleteApiResponse(url); // Gọi phương thức delete từ service
      print("Item deleted successfully");
    } catch (e) {
      print("Error deleting item: ${e.toString()}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateItemInCart(CartItemUpdateDTO request) async {
    try {
      String url = AppUrl.updateQuantityCartItemUrl; // Xây dựng URL cho cập nhật mục
      dynamic jsonResponse = await _apiService.getPutApiResponse(url, request.toJson());
      return jsonResponse;
    } catch (e) {
      print("Error updating item in cart: ${e.toString()}");
      rethrow;
    }
  }




}