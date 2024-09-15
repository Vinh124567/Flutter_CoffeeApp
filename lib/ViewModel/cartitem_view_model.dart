import 'package:coffee_shop/Repository/cart_item_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../Data/Response/api_response.dart';
import '../Model/coffee_dto.dart';

class CartItemViewModel with ChangeNotifier {
  final _myRepo = CartItemRepository();

  ApiResponse<CoffeeList> cartItemList = ApiResponse.loading();

  setCoffeeList(ApiResponse<CoffeeList> response) {
    cartItemList = response;
    notifyListeners();
  }

  Future<void> fetchCartItemListApi(String userId) async {
    setCoffeeList(ApiResponse.loading());
    _myRepo.fetchCartItemList(userId).then((value) {
      setCoffeeList(ApiResponse.completed(value));
      print('Error: $userId');
    }).onError((error, stackTrace) {
      setCoffeeList(ApiResponse.error(error.toString()));
    });
  }

}