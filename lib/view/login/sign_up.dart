import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUp();
  }
}

class _SignUp extends State<SignUp> {
  double? _devHeight, _devWidth;
  int _currentIndex = 0; // Để theo dõi bước hiện tại

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

              AnimatedSwitcher(
                duration: Duration(milliseconds: 500), // Thời gian chuyển đổi
                child: _buildStep(),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
              _signupWithFacebook(),
              SizedBox(height: _devHeight! * 0.1),
              _signIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signupWithFacebook() {
    return MaterialButton(
      onPressed: () {
        setState(() {
          if (_currentIndex < 4) {
            _currentIndex++; // Chuyển sang bước tiếp theo
          }
        });
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
            _currentIndex == 0
                ? "Bắt đầu thôi nào" // Hiển thị ban đầu
                : (_currentIndex > 4 ? "Tiếp tục" : "Hoàn tất đăng ký") ,

            // Thay đổi sau khi nhấn
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

  Widget _signIn() {
    return MaterialButton(
      onPressed: () {},
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
            "Quay lại đăng nhập",
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

  Widget _buildStep() {
    List<Widget> steps = [
      SizedBox(), 
      _buildTextField("Email"),
      _buildTextField("Mật khẩu"),
      _buildTextField("Họ tên"),
      _buildTextField("Tên"),
    ];

    return Column(
      key: ValueKey<int>(_currentIndex),
      children: [
        if (_currentIndex > 0) steps[_currentIndex],
      ],
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: TColor.gray70,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
