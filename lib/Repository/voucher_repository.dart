import '../Data/Network/base_api_service.dart';
import '../Data/Network/network_api_service.dart';
import '../Model/voucher_dto.dart';
import '../Res/app_url.dart';

class VoucherRepository{

  BaseApiService _apiService= NetworkApiService();

  Future<VoucherList> fetchVoucherList() async{
    try{
      dynamic jsonResponse = await _apiService.getGetApiResponse(AppUrl.getVoucherUrl);
      VoucherList voucherList = VoucherList.fromJson(jsonResponse);
      return voucherList;
    }catch(e){
      throw e;
    }
  }

}
