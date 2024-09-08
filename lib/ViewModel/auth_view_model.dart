
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'FirebaseAuth/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
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

  Future<void> signIn(String email, String password) async {
    setLoading(true);
    setErrorMessage(null);
    try {
      _user = await _authService.signInWithEmailAndPassword(email, password);
      setLoading(false);
      notifyListeners();
      print('Đăng nhập thành công, user: $_user');// Cập nhật trạng thái người dùng khi đăng nhập thành công
    } catch (e) {
      setLoading(false);
      setErrorMessage(e.toString()); // Lưu trữ thông báo lỗi để hiển thị lên UI
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners(); // Cập nhật giao diện khi người dùng đăng xuất
    } catch (e) {
      setErrorMessage(e.toString()); // Lưu trữ lỗi nếu có khi đăng xuất
    }
  }
}
