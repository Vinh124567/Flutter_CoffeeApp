import 'package:coffee_shop/View/Screen/login_screen.dart';
import 'package:coffee_shop/View/Screen/spending_page.dart';
import 'package:coffee_shop/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/auth_view_model.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Gap(68),
          buildHeader(),
          ListTile(
            leading: Icon(Icons.area_chart),
            title: Text('Chi tiêu'),
            onTap: () {
              // Điều hướng đến màn hình đơn hàng của bạn
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LineChartSample()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Đổi mật khẩu'),
            onTap: () {
              // Điều hướng đến màn hình thông tin tài khoản
              Navigator.pushNamed(context,RouteName.change_password_page
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {
              // Xử lý đăng xuất
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Đăng xuất"),
                    content: Text("Bạn có chắc muốn đăng xuất không?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Đóng hộp thoại
                        },
                        child: Text("Hủy"),
                      ),
                      TextButton(
                        onPressed: () async{
                          // Xử lý đăng xuất ở đây
                          final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                          await authViewModel.signOut();
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text("Đồng ý"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center( // Sử dụng Center để căn giữa
        child: Text(
          'Chi tiết tài khoản',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
      ),
    );
  }
}

// Đây chỉ là các màn hình mẫu, bạn cần tạo các màn hình tương ứng.
class DonHangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đơn hàng của bạn'),
      ),
      body: Center(
        child: Text('Nội dung đơn hàng'),
      ),
    );
  }
}

class ThongTinTaiKhoanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin tài khoản'),
      ),
      body: Center(
        child: Text('Thông tin tài khoản của bạn'),
      ),
    );
  }
}

class DangNhapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
      ),
      body: Center(
        child: Text('Màn hình đăng nhập'),
      ),
    );
  }
}
