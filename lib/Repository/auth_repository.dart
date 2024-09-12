import 'package:coffee_shop/Model/address_dto.dart';
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/user_dto.dart';
import '../Res/app_url.dart';

class AuthRepository {
  final BaseApiService _apiService = NetworkApiService();

  Future<Users> createUserAccount(Users user) async {
    try {
      String url = AppUrl.createUserUrl;
      dynamic jsonResponse = await _apiService.getPostApiResponse(
        url,
        user.toJson(),
      );
      return Users.fromJson(jsonResponse);
    } catch (e) {
      print("Error creating address: ${e.toString()}");
      rethrow;
    }
  }

}
