import 'dart:convert';
import 'dart:io';
import 'package:coffee_shop/Data/Network/base_api_service.dart';
import 'package:coffee_shop/Data/app_exceptions.dart';
import 'package:http/http.dart';

class NetworkApiService extends BaseApiService {


  @override
  Future getGetApiResponse(String url) async{
    dynamic responseJson;
    try{
      final response = await get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      responseJson= returnResponse(response);
    }on SocketException {
      throw FetchDataException('No Internet Connect');
    }
    return responseJson;
  }


  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      Response response = await post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data), // Truyền data đã là Map<String, dynamic> rồi
      ).timeout(const Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse (Response response){
    switch(response.statusCode){
      case 200:
        dynamic responseJson=jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 405:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException('Error accured while communicating with server with status code ${response.statusCode}');
    }
  }

}