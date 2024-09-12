import 'package:coffee_shop/Data/Response/api_response.dart';
import 'package:flutter/cupertino.dart';
import '../Model/voucher_dto.dart';
import '../Repository/voucher_repository.dart';

class VoucherViewModel with ChangeNotifier {
  final _myRepo = VoucherRepository();

  ApiResponse<VoucherList> voucherList = ApiResponse.loading();
  List<Voucher> selectedVouchers = []; // Danh sách voucher đã chọn

  setVoucherList(ApiResponse<VoucherList> response) {
    voucherList = response;
    notifyListeners();
  }

  Future<void> fetchVoucherListApi() async {
    setVoucherList(ApiResponse.loading());
    _myRepo.fetchVoucherList("1").then((value) {
      setVoucherList(ApiResponse.completed(value));
    }).onError((error, stackTrace) {
      print('Error occurred: $error');
      print('Stack trace: $stackTrace');

      setVoucherList(ApiResponse.error(error.toString()));
    });
  }
}
