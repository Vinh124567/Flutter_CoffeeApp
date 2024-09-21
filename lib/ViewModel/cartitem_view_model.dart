
import 'package:coffee_shop/Model/cart_item_request.dart';
import 'package:coffee_shop/Repository/cart_item_repository.dart';
import 'package:flutter/cupertino.dart';
import '../Data/Response/api_response.dart';
import '../Model/coffee_dto.dart';
class CartItemViewModel with ChangeNotifier {
  final _myRepo = CartItemRepository();

  ApiResponse<CoffeeList> cartItemList = ApiResponse.loading();
  ApiResponse<String> addItemResponse = ApiResponse.loading();
  ApiResponse<String> deleteItemResponse = ApiResponse.loading();

  setCoffeeList(ApiResponse<CoffeeList> response) {
    cartItemList = response;
    notifyListeners();
  }

  setAddItemResponse(ApiResponse<String> response) {
    addItemResponse = response;
    notifyListeners();
  }

  setDeleteItemResponse(ApiResponse<String> response) {
    deleteItemResponse = response;
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


  Future<ApiResponse<String>> addItemToCartApi(CartItemRequest cartItemRequest) async {
    setAddItemResponse(ApiResponse.loading());
    try {
      final jsonResponse = await _myRepo.addItemToCart(cartItemRequest);

      final status = jsonResponse['status'];
      final message = jsonResponse['message'];

      if (status == 200) {
        return ApiResponse.completed(message); // Thành công
      } else {
        return ApiResponse.error(message); // Thất bại
      }
    } catch (error, stackTrace) {
      print('Lỗi khi thêm item vào giỏ hàng: $error');
      print('Stacktrace: $stackTrace');
      return ApiResponse.error(error.toString());
    }
  }

  Future<void> removeItemFromCart(int? id) async {
    if (id != null) {
      setDeleteItemResponse(ApiResponse.loading());
      try {
        await _myRepo.deleteCartItem(id);
        setDeleteItemResponse(ApiResponse.completed("Item deleted successfully"));
        fetchCartItemListApi("userId"); // Thay "userId" bằng ID người dùng thực tế
      } catch (error) {
        setDeleteItemResponse(ApiResponse.error(error.toString()));
      }
    } else {
      setDeleteItemResponse(ApiResponse.error("Item ID is null"));
    }
  }



}