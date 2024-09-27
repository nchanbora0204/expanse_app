import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/firebaseService/user_services.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  double? _devHeight, _devWidth;
  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService(); // Khởi tạo dịch vụ người dùng

  @override
  Widget build(BuildContext context) {
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: TColor.gray80,
      body: SafeArea(
        child: SizedBox(
          width: _devWidth,
          height: _devHeight,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(),
                Image.asset("assets/img/app_logo.png"),
                SizedBox(height: _devHeight! * 0.3),
                _buildSignInForm(),
                const SizedBox(
                  height: 10,
                ),
                _signInWithFacebook(),
                SizedBox(height: _devHeight! * 0.1),
                _navigateToSignUp(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Container(
      child: Column(
        children: [
          _buildTextField("Email", _emailController),
          _buildTextField("Mật khẩu", _passwordController, isPassword: true),
          const SizedBox(height: 20),
          MaterialButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            width: 20,
                          ),
                          Text("Đang đăng nhập..."),
                        ],
                      ),
                    );
                  });
              bool success = await _signInUser();
              await Future.delayed(const Duration(seconds: 4));
              Navigator.of(context).pop();
              if (success) {
                print("Đăng nhập thành công!");
                Navigator.pushNamed(context, 'main_tab');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Đăng Nhập Thất Bại. Vui lòng thử lại sau"),
                  ),
                );
              }
            },
            minWidth: _devWidth! * 0.7,
            height: _devHeight! * 0.06,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage("assets/img/primary_btn.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
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
      onPressed: () async {
        // Xử lý đăng nhập với Facebook ở đây
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Đang Đăng Nhập Facebook..."),
                  ],
                ),
              );
            });
        bool success = await _userService.signInWithFacebook();

        Navigator.of(context).pop(); //Dong dialog

        if (success) {
          //Neu dang nhap thanh cong
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng Nhập Facebook thành công")),
          );
          Navigator.pushNamed(context, 'main_tab');
        } else {
          //Neu that bai
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Đăng nhập Facebook thất bại. Vui lòng thử lại")),
          );
        }
      },
      minWidth: _devWidth! * 0.7,
      height: _devHeight! * 0.06,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/img/fb_btn.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/fb.png",
              height: 24,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "Đăng nhập bằng Facebook",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
      child: SizedBox(
        width: _devWidth! * 0.85,
        height: 55,
        child: const Center(
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

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        controller: controller,
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

  Future<bool> _signInUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập đầy đủ thông tin."),
        ),
      );
      return false;
    }

    bool success =
        await _userService.signInWithEmailAndPassword(email, password);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng nhập thành công."),
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin."),
        ),
      );
      return false;
    }
  }
}
