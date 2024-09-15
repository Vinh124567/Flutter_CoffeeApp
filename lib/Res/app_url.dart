class AppUrl{
  static var baseUrl="http://10.0.2.2:8084";
  static var getCoffeeUrl='$baseUrl/coffee/getallcoffee';
  static var getVoucherUrl='$baseUrl/vouchers';
  static var resignUrl='${baseUrl}/api/register';
  static var loginUrl='${baseUrl}/api/register';
  static var createUserUrl='${baseUrl}/api/users/create';
  static String addressUrl(String userId) {
    return '$baseUrl/users/$userId/addresses';
  }

  static String voucherUrl(String userId) {
    return '$baseUrl/vouchers/users/$userId/available';
  }

  static String cartItemUrl(String userId) {
    return '$baseUrl/cart/$userId/items';
  }

  static String postAddressUrl() => '$baseUrl/users/post';

}