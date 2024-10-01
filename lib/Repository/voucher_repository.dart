import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/voucher_dto.dart';
import '../Res/app_url.dart';

class VoucherRepository{

  final BaseApiService _apiService= NetworkApiService();
  Future<VoucherList> fetchVoucherList(String userId) async{
    try{
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.voucherUrl(userId));
      VoucherList voucherList = VoucherList.fromJson(jsonResponse);
      return voucherList;
    }catch(e){
      rethrow;
    }
  }



}
