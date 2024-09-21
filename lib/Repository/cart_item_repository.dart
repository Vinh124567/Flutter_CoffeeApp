
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/cart_item_request.dart';
import '../Model/coffee_dto.dart';
import '../Res/app_url.dart';

class CartItemRepository{

  final BaseApiService _apiService= NetworkApiService();

  Future<CoffeeList> fetchCartItemList(String userId) async{
    try{
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.cartItemUrl(userId));
      CoffeeList coffeeList = CoffeeList.fromJson(jsonResponse);
      return coffeeList;
    }catch(e){
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addItemToCart(CartItemRequest cartItemRequest) async {
    try {
      String url = AppUrl.addItemCartUrl();
      dynamic jsonResponse = await _apiService.getPostApiResponse(
        url,
        cartItemRequest.toJson(),
      );
      return jsonResponse; // Trả về phản hồi JSON từ server
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
}