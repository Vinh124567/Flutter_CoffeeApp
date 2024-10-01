class AppUrl{
  static var baseUrl="http://10.0.2.2:8084";
  static var getCoffeeUrl='$baseUrl/api/v1/coffee';
  static var resignUrl='${baseUrl}/api/register';
  static var loginUrl='${baseUrl}/api/register';
  static var categoriesUrl='${baseUrl}/api/v1/categories';
  static var createUserUrl='${baseUrl}/api/users/create';
  static var updateQuantityCartItemUrl='${baseUrl}/api/v1/cart';
  static String addressUrl(String userId) {
    return '$baseUrl/users/$userId/addresses';
  }

  static String voucherUrl(String userId) {
    return '$baseUrl/api/v1/voucher/users/$userId/available';
  }


  static String cartItemUrl(String userId) {
    return '$baseUrl/api/v1/cart/$userId';
  }
  static String deleteCartItemUrl(int cartItemId) {
    return '$baseUrl/api/v1/cart/$cartItemId'; // Đường dẫn đầy đủ đến API xóa mục
  }


  static String postAddressUrl() => '$baseUrl/users/post';
  static String addItemCartUrl() => '$baseUrl/api/v1/cart';

  static String createOrderUrl() => '$baseUrl/orders';

}