import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop/ViewModel/auth_view_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đổi Mật Khẩu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: InputDecoration(labelText: "Mật khẩu hiện tại"),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: "Mật khẩu mới"),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: "Xác nhận mật khẩu mới"),
              obscureText: true,
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text("Đổi Mật Khẩu"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changePassword() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Kiểm tra xem mật khẩu mới và xác nhận mật khẩu có khớp không
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Mật khẩu xác nhận không khớp!";
      });
      return;
    }

    // Gọi hàm đổi mật khẩu từ ViewModel
    try {
      await authViewModel.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      // Chỉ hiển thị thông báo thành công nếu không có ngoại lệ nào
      if (authViewModel.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đổi mật khẩu thành công!")),
        );
        Navigator.pop(context); // Quay lại màn hình trước
      } else {
        // Nếu có lỗi, hiển thị thông báo lỗi
        setState(() {
          _errorMessage = authViewModel.errorMessage; // Hiển thị lỗi nếu có
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage ="Mật khẩu hiện tại không chính xác"; // Hiển thị lỗi nếu có
      });
    }
  }
}
