import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int _currentIndex = 0;
  bool _obscureText = true;

  //Khai báo controller để lưu dữ liệu.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  //firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              _signupButtom(),
              SizedBox(height: _devHeight! * 0.1),
              _signIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signupButtom() {
    return MaterialButton(
      onPressed: () async {
        if (_currentIndex < 4) {
          setState(() {
            _currentIndex++;
          });
        } else {
          //Thuc hien dang ky Firebase
          try {
            final UserCredential userCredential =
                await _auth.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );

            //Luu thong tin nguoi dung len firestore
            await FirebaseFirestore.instance
                .collection('user')
                .doc(userCredential.user!.uid)
                .set({
              'email': _emailController.text,
              'fullname': _fullnameController.text,
              'lastName': _lastnameController.text,
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Đăng Ký Thành Công!"),
              ),
            );

            //Dieu huong toi trang chinh khi dang ky thanh cong
            Navigator.pushNamed(context, 'main_tab');
          } catch (e) {
            print("Đăng Ký Thất Bại: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Đăng Ký Thất Bại. Vui Lòng Thử Lại: ${e.toString()}"),
              ),
            );
            //Hien thi thong bao loi
          }
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
            _currentIndex == 0
                ? "Bắt đầu thôi nào" // Hiển thị ban đầu
                : (_currentIndex > 4 ? "Hoàn Tất Đăng Ký" : "Tiếp Tục"),

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
      onPressed: () {
        Navigator.pushNamed(context, 'sign_in');
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
            "Đã Có Tài Khoản? Đăng Nhập",
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
      _buildTextField("Email", controller: _emailController),
      _buildTextField("Mật khẩu",
          isPassword: true, controller: _passwordController),
      _buildTextField("Họ tên", controller: _fullnameController),
      _buildTextField("Tên", controller: _lastnameController),
    ];

    return Column(
      key: ValueKey<int>(_currentIndex),
      children: [
        if (_currentIndex > 0) steps[_currentIndex],
      ],
    );
  }

  Widget _buildTextField(String hint,
      {bool isPassword = false, required TextEditingController controller}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        obscureText: isPassword ? _obscureText : false,
        // Áp dụng thuộc tính obscureText
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
