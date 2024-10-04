import 'dart:ffi';

class AppUrl{
  static var baseUrl="http://10.0.2.2:8084";
  static var getCoffeeUrl='$baseUrl/api/v1/coffee';
  static var resignUrl='${baseUrl}/api/register';
  static var loginUrl='${baseUrl}/api/register';
  static var categoriesUrl='${baseUrl}/api/v1/categories';
  static var createUserUrl='${baseUrl}/api/v1/users';
  static var updateQuantityCartItemUrl='${baseUrl}/api/v1/cart';
  static var postAddressUrl = '$baseUrl/api/v1/address';
  static var addItemCartUrl = '$baseUrl/api/v1/cart';
  static var createOrderUrl = '$baseUrl/api/v1/orders';
  static var newReviewUrl = '$baseUrl/api/v1/coffee/addReview';
  static String addressUrl(String userId) {
    return '$baseUrl/api/v1/address/$userId';
  }

  static String voucherUrl(String userId) {
    return '$baseUrl/api/v1/voucher/users/$userId/available';
  }

  static String coffeeNotReviewUrl(String userId) {
    return '$baseUrl/api/v1/order-items/$userId';
  }

  static String cartItemUrl(String userId) {
    return '$baseUrl/api/v1/cart/$userId';
  }
  static String deleteCartItemUrl(int cartItemId) {
    return '$baseUrl/api/v1/cart/$cartItemId';
  }

  static String getOrderUrl(String userId, String orderStatus) {
    return '$baseUrl/api/v1/orders?userId=$userId&orderStatus=$orderStatus';
  }

  static String updateOrderStatusUrl(int orderId, String orderStatus, String paymentStatus) {
    return '$baseUrl/api/v1/orders/$orderId?orderStatus=$orderStatus&paymentStatus=$paymentStatus';
  }

}