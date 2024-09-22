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
  int _currentIndex = 0; // Để theo dõi bước hiện tại

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final UserService _userService = UserService(); // Khởi tạo UserService

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
              if (_currentIndex > 0)
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      if (_currentIndex > 0) {
                        _currentIndex--; // Lùi lại bước trước
                      }
                    });
                  },
                ),
              Image.asset("assets/img/app_logo.png"),
              SizedBox(height: _devHeight! * 0.3),

              AnimatedSwitcher(
                duration: Duration(milliseconds: 500), // Thời gian chuyển đổi
                child: _buildStep(),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
              _signupButton(),
              SizedBox(height: _devHeight! * 0.1),
              _signIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signupButton() {
    return MaterialButton(
      onPressed: () async {
        if (_currentIndex < 2) {
          // Cập nhật trạng thái (state) đồng bộ
          setState(() {
            _currentIndex++; // Chuyển sang bước tiếp theo
          });
        } else {
          // Thực hiện đăng ký - xử lý async bên ngoài setState
          bool success = await _registerUser();
          if (success) {
            setState(() {
              // Cập nhật UI sau khi đăng ký thành công
              print("Đăng ký hoàn tất!");
              // Có thể chuyển trang hoặc thông báo thành công ở đây
            });
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
                ? "Tiếp tục" // Bước 1
                : _currentIndex == 1
                ? "Tiếp tục" // Bước 2
                : "Hoàn tất đăng ký", // Bước 3
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
        // Logic quay lại đăng nhập
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
      _buildTextField("Email", _emailController), // Bước 1: Nhập Email
      _buildTextField("Mật khẩu", _passwordController), // Bước 2: Nhập Password
      _buildTextField("Họ tên", _nameController), // Bước 3: Nhập Họ Tên
    ];

    return Column(
      key: ValueKey<int>(_currentIndex),
      children: [
        steps[_currentIndex], // Hiển thị bước hiện tại
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: TextField(
        controller: controller, // Nhận giá trị từ controller
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

  // Hàm đăng ký tài khoản
  Future<bool> _registerUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      // Xử lý nếu các trường rỗng
      print('Vui lòng nhập đầy đủ thông tin.');
      return false;
    }

    UserModel? user = await _userService.registerWithEmailAndPassword(name, email, password);

    if (user != null) {
      // Đăng ký thành công
      print("Đăng ký thành công với UID: ${user.uid}");
      return true;
    } else {
      // Đăng ký thất bại
      print('Đăng ký thất bại.');
      return false;
    }
  }
}
