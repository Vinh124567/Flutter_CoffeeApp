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
  Future<void> signUp(String email, String password) async {
    setLoading(true);
    setErrorMessage(null);
    try {
      _user = await _authService.createUserWithEmailAndPassword(email, password);
      setLoading(false);
      notifyListeners();
      print('Đăng ký thành công, user: $_user');
    } catch (e) {
      setLoading(false);
      setErrorMessage(e.toString());
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
