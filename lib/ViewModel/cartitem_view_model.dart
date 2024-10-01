import 'dart:async';

import 'package:coffee_shop/Model/Cart/cart_item_create_request.dart';
import 'package:coffee_shop/Model/Cart/cart_item_update_request.dart';
import 'package:coffee_shop/Model/Cart/cart_response.dart';
import 'package:coffee_shop/Repository/cart_item_repository.dart';
import 'package:flutter/cupertino.dart';
import '../Data/Response/api_response.dart';
import '../Model/Cart/cart_mapper.dart';

class CartItemViewModel with ChangeNotifier {
  final _myRepo = CartItemRepository();

  ApiResponse<CartResponse> cartItemResponse = ApiResponse.loading();
  ApiResponse<String> addItemResponse = ApiResponse.loading();
  ApiResponse<String> deleteItemResponse = ApiResponse.loading();
  ApiResponse<String> updateItemResponse = ApiResponse.loading();
  List<CartItemData> _localCartItems = []; // Danh sách giỏ hàng local
  Timer? _debounce;

  // Getter cho danh sách giỏ hàng local
  List<CartItemData> get localCartItems => _localCartItems;

  setCartItemResponse(ApiResponse<CartResponse> response) {
    cartItemResponse = response;
    notifyListeners();
  }

  setUpdateItemResponse(ApiResponse<String> response) { // Phương thức để cập nhật phản hồi
    updateItemResponse = response;
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

  void increaseQuantity(CartItemData coffeeItem) {
    coffeeItem.quantity = (coffeeItem.quantity ?? 0) + 1;
    notifyListeners(); // Cập nhật giao diện
    _updateCartItemQuantity(coffeeItem.id, coffeeItem.quantity);
  }

  // Phương thức giảm số lượng
  void decreaseQuantity(CartItemData coffeeItem) {
    if (coffeeItem.quantity != null && coffeeItem.quantity! > 1) {
      coffeeItem.quantity = coffeeItem.quantity! - 1;
      notifyListeners(); // Cập nhật giao diện
      _updateCartItemQuantity(coffeeItem.id, coffeeItem.quantity);
    }
  }


  // Phương thức cập nhật số lượng lên server
  void _updateCartItemQuantity(int? cartItemId, int? newQuantity) {
    if (cartItemId == null || newQuantity == null) return;
    // Hủy timer cũ nếu có
    _debounce?.cancel();

    // Tạo timer mới
    _debounce = Timer(const Duration(seconds: 2), () {
      _sendUpdateToServer(cartItemId, newQuantity);
    });
  }

  // Gửi yêu cầu cập nhật đến server
  Future<void> _sendUpdateToServer(int cartItemId, int newQuantity) async {
    // Tạo đối tượng CartItemUpdateDTO với các tham số đã cung cấp
    CartItemUpdateDTO requestBody = CartItemUpdateDTO(
      id: cartItemId, // Giả sử `id` ở đây là ID của item trong giỏ hàng
      quantity: newQuantity, // Số lượng mới
    );

    setUpdateItemResponse(ApiResponse.loading()); // Đặt trạng thái đang tải
    try {
      // Gọi phương thức cập nhật từ repository
      final jsonResponse = await _myRepo.updateItemInCart(requestBody);
      final status = jsonResponse['status'];
      final message = jsonResponse['message'];

      // Xử lý mã trạng thái 200 và 201
      if (status == 200 || status == 201) {
        setUpdateItemResponse(ApiResponse.completed(message)); // Thành công
      } else {
        setUpdateItemResponse(ApiResponse.error(message)); // Thất bại
      }
    } catch (error) {
      print('Lỗi khi cập nhật số lượng sản phẩm: $error');
      setUpdateItemResponse(ApiResponse.error(error.toString())); // Xử lý lỗi
    }
  }



  Future<void> fetchCartItemListApi(String userId) async {
    setCartItemResponse(ApiResponse.loading());
    _myRepo.fetchCartItemList(userId).then((value) {
      setCartItemResponse(ApiResponse.completed(value));
      _localCartItems = value.data?.cartItems ?? [];
    }).onError((error, stackTrace) {
      setCartItemResponse(ApiResponse.error(error.toString()));
    });
  }

  Future<ApiResponse<String>> addItemToCartApi(CartItemData request) async {


      final existingItem = _localCartItems.firstWhere(
            (cartItem) =>
        cartItem.coffeeData?.coffeeId == request.coffeeData?.coffeeId &&
            cartItem.size == request.size,
        orElse: () => CartItemData(quantity: 0),
      );

      if (existingItem != null) {
        // Nếu sản phẩm đã tồn tại, tăng số lượng
        existingItem.quantity = (existingItem.quantity ?? 0) + 1; // Sử dụng ?? để đảm bảo không bị null
      } else {
        // Nếu không, thêm sản phẩm mới vào giỏ hàng
        _localCartItems.add(request);
      }

      notifyListeners(); // Cập nhật giao diện

    CartItemCreateDTO cartItemAddRequest = CartItemMapper.fromDataToDTO(request, cartItemResponse.data!.data!.userId.toString());

    setAddItemResponse(ApiResponse.loading());
    try {
      final jsonResponse = await _myRepo.addItemToCart(cartItemAddRequest);
      final status = jsonResponse['status'];
      final message = jsonResponse['message'];

      // Xử lý mã trạng thái 200 và 201
      if (status == 200 || status == 201) {
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



  Future<void> removeItemFromCart(int? id, String userId) async {
    if (id != null) {
      setDeleteItemResponse(ApiResponse.loading()); // Bắt đầu quá trình xóa
      try {
        await _myRepo.deleteCartItem(id); // Gọi API để xóa item
        // Xóa item khỏi danh sách cục bộ
        _localCartItems.removeWhere((item) => item.id == id); // Giả sử _localCartItems là danh sách chứa các item
        setDeleteItemResponse(ApiResponse.completed("Item deleted successfully")); // Thông báo xóa thành công

        // Gọi lại fetchCartItemListApi để cập nhật danh sách từ server
        await fetchCartItemListApi(userId);
        notifyListeners(); // Cập nhật giao diện
      } catch (error) {
        setDeleteItemResponse(ApiResponse.error(error.toString())); // Thông báo lỗi nếu có
      }
    } else {
      setDeleteItemResponse(ApiResponse.error("Item ID is null")); // Thông báo nếu ID null
    }
  }





}
