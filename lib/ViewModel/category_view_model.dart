import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:coffee_shop/Model/category_dto.dart';
import 'package:coffee_shop/Repository/categories_repository.dart';
import 'package:flutter/cupertino.dart';


class CategoriesViewModel with ChangeNotifier {
  final _myRepo = CategoriesRepository();
  ApiResponse<CategoriesDTO> listCategories = ApiResponse.loading();

  setCategoriesList(ApiResponse<CategoriesDTO> response) {
    listCategories = response;
    notifyListeners();
  }

  Future<void> fetchCategoriesListApi() async {
    print("Fetching categories..."); // Log khi bắt đầu gọi API
    setCategoriesList(ApiResponse.loading());
    _myRepo.fetchCategoriesList().then((value) {
      print("Fetched categories successfully!");
      setCategoriesList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      print("Error occurred: $error"); // In ra lỗi
      setCategoriesList(ApiResponse.error(error.toString()));
    });
  }
}
