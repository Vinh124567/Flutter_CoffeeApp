import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:coffee_shop/Repository/home_repository.dart';
import 'package:flutter/cupertino.dart';

import '../Model/Coffees/coffee_response.dart';

class HomeViewModel with ChangeNotifier {
  final _myRepo = HomeRepository();

  ApiResponse<CoffeeResponse> coffeeList = ApiResponse.loading();

  setCoffeeList(ApiResponse<CoffeeResponse> response) {
    coffeeList = response;
    notifyListeners();
  }

  Future<void> fetchCoffeeListApi() async {
    print("Fetching coffee list..."); // Log khi bắt đầu gọi API
    setCoffeeList(ApiResponse.loading());
    _myRepo.fetchCoffeeList().then((value) {
      print("Fetched coffee list successfully!");
      setCoffeeList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      print("Error occurred: $error"); // In ra lỗi
      setCoffeeList(ApiResponse.error(error.toString()));
    });
  }
}
