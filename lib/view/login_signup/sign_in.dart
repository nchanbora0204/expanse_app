import 'package:flutter/material.dart';

import 'package:money_lover/firebaseService/user_services.dart';
import 'package:money_lover/models/user_model.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  double? _devHeight, _devWidth;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Container(
          width: _devWidth,
          height: _devHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/img/app_logo.png"),
              SizedBox(height: _devHeight! * 0.05),
              _buildTextField("Email", _emailController),
              _buildTextField("Mật khẩu", _passwordController, obscureText: true),
              SizedBox(height: _devHeight! * 0.05),
              _signInButton(),
              _signUpRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return MaterialButton(
      onPressed: () async {
        bool success = await _signInUser();
        if (success) {
          // Điều hướng sau khi đăng nhập thành công
          print('Đăng nhập thành công!');
          Navigator.pushReplacementNamed(context, 'main_tab');
          // Navigator.pushReplacement... (Chuyển sang trang khác)
        } else {
          // Xử lý khi đăng nhập thất bại
          print('Đăng nhập thất bại.');
        }
      },
      minWidth: _devWidth! * 0.7,
      height: _devHeight! * 0.06,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/primary_btn.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            "Đăng nhập",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpRedirect() {
    return MaterialButton(
      onPressed: () {
        // Điều hướng sang trang đăng ký
        Navigator.pushNamed(context, '/signup');
      },
      color: Colors.grey[700],
      minWidth: _devWidth! * 0.7,
      height: _devHeight! * 0.06,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        width: _devWidth! * 0.85,
        height: 55,
        child: Center(
          child: Text(
            "Đăng ký tài khoản",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool obscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[700],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<bool> _signInUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      print('Vui lòng nhập đầy đủ thông tin.');
      return false;
    }

    UserModel? user = await _userService.signInWithEmailAndPassword(email, password);

    return user != null;
  }
}
