import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/Repository/address_repository.dart';
import 'package:flutter/cupertino.dart';

class AddressViewModel with ChangeNotifier {

  Address? _selectedAddress;

  Address? get selectedAddress => _selectedAddress;

  void setSelectedAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }

  final _myRepo = AddressRepository();

  ApiResponse<AddressDTO> addressList = ApiResponse.loading();
  ApiResponse<Address> createAddressResponse = ApiResponse.loading();

  void setAddressList(ApiResponse<AddressDTO> response) {
    addressList = response;
    notifyListeners();
  }

  void setCreateAddressResponse(ApiResponse<Address> response) {
    createAddressResponse = response;
    notifyListeners();
  }

  Future<void> fetchAddressListApi() async {
    setAddressList(ApiResponse.loading());
    try {
      AddressDTO addresses = await _myRepo.fetchAddressList("1");
      setAddressList(ApiResponse.completed(addresses));
    } catch (error) {
      setAddressList(ApiResponse.error(error.toString()));
    }
  }

  Future<void> addAddressApi(Address address) async {
    setCreateAddressResponse(ApiResponse.loading());
    try {
      Address newAddress = await _myRepo.createAddress(address);
      setCreateAddressResponse(ApiResponse.completed(newAddress));
    } catch (error, stacktrace) {
      // In lỗi ra console
      print('Lỗi khi thêm địa chỉ: $error');
      print('Stacktrace: $stacktrace');

      // Cập nhật phản hồi lỗi
      setCreateAddressResponse(ApiResponse.error(error.toString()));
    }
  }

}
