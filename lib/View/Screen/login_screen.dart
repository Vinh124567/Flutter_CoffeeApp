import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_shop/ViewModel/auth_view_model.dart';
import '../../Utils/utils.dart';
import '../../routes/route_name.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Thêm SingleChildScrollView
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 10),
        child: Form(
          key: _formKey,
          child: Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              // Điều hướng nếu người dùng đã đăng nhập
              if (authViewModel.user != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacementNamed(context, RouteName.home);
                });
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 50),
                  if (authViewModel.errorMessage != null)
                    Text(
                      authViewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "PassWord",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(

                    onPressed: authViewModel.loading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        authViewModel.signIn(
                          _emailController.text,
                          _passwordController.text,
                          context,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: const Size(200, 50),
                    ),
                    child: authViewModel.loading
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : const Text("Login", style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Chưa có tài khoản?"),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteName.register);
                        },
                        highlightColor: Colors.blue.withOpacity(0.1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: const Center(
                            child: Text(
                              ' Đăng ký ngay',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
