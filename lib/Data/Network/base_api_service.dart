 abstract class BaseApiService{
  Future<dynamic> getGetApiResponse(String Url);
  Future<dynamic> getPostApiResponse(String Url,dynamic data);
  Future<dynamic> getDeleteApiResponse(String url);
  Future<dynamic> getPutApiResponse(String url, dynamic data);
 }