import 'package:coffee_shop/Repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Model/user_dto.dart';
import 'FirebaseAuth/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AuthRepository authRepository= AuthRepository();
  bool _loading = false;
  User? _user;
  String? _errorMessage;

  bool get loading => _loading;
  User? get user => _user;
  String? get errorMessage => _errorMessage;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Kiểm tra trạng thái đăng nhập
  // Kiểm tra trạng thái đăng nhập
  Future<void> checkLoginStatus() async {
    setLoading(true);
    _user = FirebaseAuth.instance.currentUser;
    setLoading(false);
    notifyListeners();
  }

  // Đăng nhập
  Future<void> signIn(String email, String password) async {
    setLoading(true);
    setErrorMessage(null);
    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
      setLoading(false);
      notifyListeners();
      print('Đăng nhập thành công, user: $_user');
    } catch (e) {
      setLoading(false);
      setErrorMessage(e.toString());
    }
  }

  // Đăng ký
  Future<void> registerAndPushUser(String email, String password, String userName) async {
    setLoading(true); // Bắt đầu trạng thái loading
    setErrorMessage(null); // Xóa thông báo lỗi trước khi bắt đầu

    try {
      // Đăng ký người dùng với email và mật khẩu
      _user = await _authService.createUserWithEmailAndPassword(email, password);
      // Tạo đối tượng User với thông tin đã đăng ký
      final user = Users(id: _user?.uid, userName: userName, email: _user?.email);
      // Gửi thông tin người dùng lên máy chủ
      await authRepository.createUserAccount(user);
      setLoading(false); // Kết thúc trạng thái loading
      notifyListeners(); // Cập nhật giao diện người dùng
    } catch (e) {
      setLoading(false); // Kết thúc trạng thái loading ngay cả khi có lỗi
      setErrorMessage(e.toString()); // Cập nhật thông báo lỗi
      notifyListeners(); // Cập nhật giao diện người dùng
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      setErrorMessage(e.toString());
    }
  }
}
