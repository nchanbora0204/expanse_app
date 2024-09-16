import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  double? _devHeight, _devWidth;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.gray80,
      body: SafeArea(
        child: Container(
          width: _devWidth,
          height: _devHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              Image.asset("assets/img/app_logo.png"),
              SizedBox(height: _devHeight! * 0.3),

              _buildSignInForm(),
              _signInWithFacebook(),
              SizedBox(height: _devHeight! * 0.1),
              _navigateToSignUp(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Container(
      child: Column(
        children: [
          _buildTextField("Email"),
          _buildTextField("Mật khẩu", isPassword: true),
          SizedBox(height: 20),
          MaterialButton(
            onPressed: () {
              // Xử lý đăng nhập ở đây
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
          ),
        ],
      ),
    );
  }

  Widget _signInWithFacebook() {
    return MaterialButton(
      onPressed: () {
        // Xử lý đăng nhập với Facebook ở đây
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
            "Đăng nhập bằng Facebook",
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

  Widget _navigateToSignUp() {
    return MaterialButton(
      onPressed: () {
        Navigator.pushNamed(context, 'sign_up');
      },
      color: TColor.gray70,
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
            "Chưa có tài khoản? Đăng ký",
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

  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        obscureText: isPassword ? _obscureText : false,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: TColor.gray70,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}
