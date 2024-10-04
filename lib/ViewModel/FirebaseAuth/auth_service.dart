import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../Utils/utils.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đăng nhập bằng email và mật khẩu
  Future<User?> signInWithEmailAndPassword(String email, String password,BuildContext context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      if (e.toString().contains("blocked all requests from this device")) {
        Utils.flushBarErrorMessage(
          "Tài khoản đã bị tạm thời khóa do nhiều lần đăng nhập không thành công. Vui lòng thử lại sau.",
          context,
        );
      } else {
        Utils.flushBarErrorMessage("Thông tin tài khoản hoặc mật khẩu không chính xác", context);
      }
      return null;
    }
  }

  // Đăng ký tài khoản mới bằng email và mật khẩu
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Error during sign-up: $e');
      return null;
    }
  }

  // Cập nhật mật khẩu cho người dùng
  Future<void> updatePassword(String newPassword) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);
        print('Mật khẩu đã được cập nhật thành công');
      } catch (e) {
        print('Error updating password: $e');
        throw Exception('Cập nhật mật khẩu không thành công: $e');
      }
    } else {
      throw Exception("Người dùng chưa đăng nhập");
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
