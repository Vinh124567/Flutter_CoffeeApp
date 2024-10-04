import 'package:coffee_shop/Model/address_dto.dart';
import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Res/app_url.dart';

class AddressRepository {
  final BaseApiService _apiService = NetworkApiService();
  Future<AddressDTO> fetchAddressList(String userId) async {
    try {
      String url = AppUrl.addressUrl(userId);
      dynamic jsonResponse = await _apiService.getGetApiResponse(url);
      AddressDTO addressList = AddressDTO.fromJson(jsonResponse);
      return addressList;
    } catch (e) {
      rethrow;
    }
  }

  Future<Address> createAddress(Address address) async {
    try {
      String url = AppUrl.postAddressUrl;
      dynamic jsonResponse = await _apiService.getPostApiResponse(
        url,
        address.toJson(), // Đảm bảo address.toJson() trả về Map<String, dynamic>
      );
      return Address.fromJson(jsonResponse);
    } catch (e) {
      print("Error creating address: ${e.toString()}");
      rethrow;
    }
  }

  Future<AddressDTO> updateAddress(Address address) async {
    try {
      String url = AppUrl.postAddressUrl;
      dynamic jsonResponse = await _apiService.getPutApiResponse(
        url,
        address.toJson(),
      );
      return AddressDTO.fromJson(jsonResponse);
    } catch (e) {
      print("Error update address: ${e.toString()}");
      rethrow;
    }
  }

}
