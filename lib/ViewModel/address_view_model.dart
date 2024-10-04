import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/Repository/address_repository.dart';
import 'package:flutter/cupertino.dart';

class AddressViewModel with ChangeNotifier {
  Address? _selectedAddress; // Địa chỉ được chọn

  Address? get selectedAddress => _selectedAddress; // Getter cho địa chỉ đã chọn

  final _myRepo = AddressRepository();
  ApiResponse<AddressDTO> addressList = ApiResponse.loading();
  ApiResponse<Address> createAddressResponse = ApiResponse.loading();
  ApiResponse<String> updateAddressResponse = ApiResponse.loading();

  // Cập nhật địa chỉ đã chọn và thông báo cho UI
  void setSelectedAddress(Address? address) {
    _selectedAddress = address;
    notifyListeners(); // Thông báo cho UI về sự thay đổi
  }

  // Cập nhật danh sách địa chỉ và thông báo cho UI
  void setAddressList(ApiResponse<AddressDTO> response) {
    addressList = response;
    notifyListeners();
  }

  // Cập nhật phản hồi tạo địa chỉ và thông báo cho UI
  void setCreateAddressResponse(ApiResponse<Address> response) {
    createAddressResponse = response;
    notifyListeners();
  }

  void setUpdateAddressResponse(ApiResponse<String> response) {
    updateAddressResponse = response;
    notifyListeners();
  }

  Future<void> fetchAddressListApi(String userId) async {
    setAddressList(ApiResponse.loading()); // Đặt trạng thái loading
    try {
      AddressDTO addresses = await _myRepo.fetchAddressList(userId);
      setAddressList(ApiResponse.completed(addresses));
      if (_selectedAddress != null && !addresses.data!.contains(_selectedAddress)) {
      }
    } catch (error) {
      setAddressList(ApiResponse.error(error.toString()));
    }
  }

  // Hàm gọi API để thêm địa chỉ
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

  Future<void> updateAddress(Address address) async {
    setUpdateAddressResponse(ApiResponse.loading());
    try {
      final response = await _myRepo.updateAddress(address);
      setUpdateAddressResponse(ApiResponse.completed("Cập nhập thành công"));
    } catch (error) {
      print("Đã xảy ra lỗi: $error");
      setUpdateAddressResponse(ApiResponse.error(error.toString()));
    }
  }
}
