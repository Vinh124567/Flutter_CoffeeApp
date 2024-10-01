
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/Coffees/coffee_response.dart';
import '../Res/app_url.dart';

class HomeRepository{

  final BaseApiService _apiService= NetworkApiService();

  Future<CoffeeResponse> fetchCoffeeList() async{
    try{
      // Lấy dữ liệu từ API
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.getCoffeeUrl);
      CoffeeResponse coffeeList = CoffeeResponse.fromJson(jsonResponse);
      return coffeeList;

    }catch(e){
      rethrow;
    }
  }
}