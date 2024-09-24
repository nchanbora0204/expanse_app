import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/firebaseService/user_services.dart';
import 'package:money_lover/models/user_model.dart';


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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final UserService _userService = UserService();

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
                if (_currentIndex > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (_currentIndex > 0) {
                          _currentIndex--;
                        }
                      });
                    },
                  ),
                Image.asset("assets/img/app_logo.png"),
                SizedBox(height: _devHeight! * 0.3),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildStep(),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
                _signupButton(),
                SizedBox(height: _devHeight! * 0.3),
                _signIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return MaterialButton(
      onPressed: () async {
        if (_currentIndex < 2) {
          setState(() {
            _currentIndex++;
          });
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const AlertDialog(
                  content: Row(
                    children:  <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Đang Đăng Ký..."),
                    ],
                  ),
                );
              });
          bool success = await _registerUser();
          await Future.delayed(
            const Duration(seconds: 4),
          );
          Navigator.of(context).pop();
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Đăng ký hoàn tất!"),
              ),
            );
            print("Đăng ký hoàn tất!");
            // Chuyển trang hoặc thông báo thành công
            Navigator.pushNamed(context, 'main_tab');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đăng ký thất bại, vui lòng thử lại")),
            );
          }
        }
      },
      minWidth: _devWidth! * 0.7,
      height: _devHeight! * 0.06,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image:  AssetImage("assets/img/primary_btn.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            _currentIndex == 0
                ? "Tiếp tục"
                : _currentIndex == 1
                ? "Tiếp tục"
                : "Hoàn tất đăng ký",
            style: const TextStyle(
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
        child: const Center(
          child: Text(
            "Quay lại đăng nhập",
            style: const TextStyle(
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
      _buildTextField("Email", _emailController),
      _buildPasswordField("Mật khẩu", _passwordController),
      _buildTextField("Họ tên", _nameController),
    ];

    return Column(
      key: ValueKey<int>(_currentIndex),
      children: [
        steps[_currentIndex],
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        controller: controller,
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

  Widget _buildPasswordField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        controller: controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: TColor.gray70,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
    );
  }

  Future<bool> _registerUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      print('Vui lòng nhập đầy đủ thông tin.');
      return false;
    }

    UserModel? user =
    await _userService.registerWithEmailAndPassword(name, email, password);

    if (user != null) {
      print("Đăng ký thành công với UID: ${user.uid}");
      return true;
    } else {
      print('Đăng ký thất bại.');
      return false;
    }
  }
}