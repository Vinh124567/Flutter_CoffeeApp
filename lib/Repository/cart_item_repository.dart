
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
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
}