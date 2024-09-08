import 'package:coffee_shop/Data/Network/base_api_service.dart';
import 'package:coffee_shop/Data/Network/network_api_service.dart';
import 'package:coffee_shop/Res/app_url.dart';

class AuthResponsitory{
  BaseApiService _apiService= NetworkApiService();

  Future<dynamic> loginApi(dynamic data) async{
    try{
      dynamic response =await _apiService.getPostApiResponse(AppUrl.loginUrl,data);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> registerApi(dynamic data) async{
      try{
        dynamic response= await _apiService.getGetApiResponse(AppUrl.resignUrl);
        return response;
      }catch(e){
        throw e;
      }
  }
}