
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/coffee_dto.dart';
import '../Res/app_url.dart';

class HomeRepository{

  BaseApiService _apiService= NetworkApiService();

  Future<CoffeeList> fetchCoffeeList() async{
    try{
      // Lấy dữ liệu từ API
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.getCoffeeUrl);
      CoffeeList coffeeList = CoffeeList.fromJson(jsonResponse);
      return coffeeList;

    }catch(e){
      throw e;
    }
  }
}