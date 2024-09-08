import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:coffee_shop/Repository/home_repository.dart';
import 'package:flutter/cupertino.dart';

import '../Model/coffee_dto.dart';

class HomeViewModel with ChangeNotifier {
  final _myRepo = HomeRepository();

  ApiResponse<CoffeeList> coffeeList = ApiResponse.loading();

  setCoffeeList(ApiResponse<CoffeeList> response) {
    coffeeList = response;
    notifyListeners();
  }

  Future<void> fetchCoffeeListApi() async {
    setCoffeeList(ApiResponse.loading());
    _myRepo.fetchCoffeeList().then((value) {
      setCoffeeList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      setCoffeeList(ApiResponse.error(error.toString()));
    });
  }
}
