class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

// Ngoại lệ khi không thể lấy dữ liệu
class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, 'Error During Communication: ');
}

// Ngoại lệ cho yêu cầu không hợp lệ
class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Invalid Request: ');
}

// Ngoại lệ khi không được phép
class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, 'Unauthorised Request: ');
}

// Ngoại lệ khi dữ liệu đầu vào không hợp lệ
class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, 'Invalid Input: ');
}

// Ngoại lệ khi server không phản hồi
class ServerException extends AppException {
  ServerException([String? message]) : super(message, 'Server Error: ');
}

// Ngoại lệ khi không tìm thấy tài nguyên (404)
class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message, 'Resource Not Found: ');
}

// Ngoại lệ khi kết nối bị gián đoạn hoặc không thành công
class ConnectionException extends AppException {
  ConnectionException([String? message]) : super(message, 'Connection Error: ');
}

// Ngoại lệ khi người dùng không được phép truy cập tài nguyên
class ForbiddenException extends AppException {
  ForbiddenException([String? message]) : super(message, 'Forbidden: ');
}

// Ngoại lệ khi vượt quá giới hạn yêu cầu
class TooManyRequestsException extends AppException {
  TooManyRequestsException([String? message]) : super(message, 'Too Many Requests: ');
}
