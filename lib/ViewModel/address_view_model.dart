import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:coffee_shop/Model/address_dto.dart';
import 'package:coffee_shop/Repository/address_repository.dart';
import 'package:flutter/cupertino.dart';

class AddressViewModel with ChangeNotifier {
  Address? _selectedAddress; // Địa chỉ được chọn

  Address? get selectedAddress => _selectedAddress; // Getter cho địa chỉ đã chọn

  final _myRepo = AddressRepository(); // Tạo instance của AddressRepository
  ApiResponse<AddressDTO> addressList = ApiResponse.loading(); // Trạng thái danh sách địa chỉ
  ApiResponse<Address> createAddressResponse = ApiResponse.loading(); // Trạng thái tạo địa chỉ

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

  // Hàm gọi API để lấy danh sách địa chỉ
  Future<void> fetchAddressListApi(String userId) async {
    setAddressList(ApiResponse.loading()); // Đặt trạng thái loading
    try {
      AddressDTO addresses = await _myRepo.fetchAddressList(userId); // Gọi API để lấy địa chỉ
      setAddressList(ApiResponse.completed(addresses)); // Cập nhật danh sách địa chỉ

      // Nếu địa chỉ đã chọn không còn trong danh sách, giữ lại địa chỉ đã chọn
      if (_selectedAddress != null && !addresses.data!.contains(_selectedAddress)) {
        // Nếu bạn muốn, bạn có thể giữ lại địa chỉ đã chọn bằng cách không đặt lại
        // Hoặc, nếu bạn muốn đặt lại, hãy uncomment dòng dưới
        // _selectedAddress = null;
      }
    } catch (error) {
      setAddressList(ApiResponse.error(error.toString())); // Cập nhật phản hồi lỗi
    }
  }

  // Hàm gọi API để thêm địa chỉ
  Future<void> addAddressApi(Address address) async {
    setCreateAddressResponse(ApiResponse.loading()); // Đặt trạng thái loading
    try {
      Address newAddress = await _myRepo.createAddress(address); // Gọi API để thêm địa chỉ
      setCreateAddressResponse(ApiResponse.completed(newAddress)); // Cập nhật phản hồi thành công
    } catch (error, stacktrace) {
      // In lỗi ra console
      print('Lỗi khi thêm địa chỉ: $error');
      print('Stacktrace: $stacktrace');

      // Cập nhật phản hồi lỗi
      setCreateAddressResponse(ApiResponse.error(error.toString()));
    }
  }
}
