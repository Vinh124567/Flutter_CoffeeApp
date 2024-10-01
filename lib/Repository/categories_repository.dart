import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/Model/category_dto.dart';
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Res/app_url.dart';

class CategoriesRepository {

  final BaseApiService _apiService = NetworkApiService();

  Future<CategoriesDTO> fetchCategoriesList() async {
    try {
      String url = AppUrl.categoriesUrl;
      dynamic jsonResponse = await _apiService.getGetApiResponse(url);
      CategoriesDTO listCategories = CategoriesDTO.fromJson(jsonResponse);
      return listCategories;
    } catch (e) {
      rethrow;
    }
  }
}
