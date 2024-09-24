import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';

class SocialSignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignupSocial();
  }
}

class _SignupSocial extends State<SocialSignUp> {
  double? _devHegiht, _devWidth;

  @override
  Widget build(BuildContext context) {
    _devHegiht = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      backgroundColor: TColor.gray80,
      body: SafeArea(
        child: Container(
          width: _devWidth,
          height: _devHegiht,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(),
              Image.asset("assets/img/app_logo.png"),
              SizedBox(
                height: _devHegiht! * 0.1,
              ),
              Container(
                height:300,
                child:  Image.asset("assets/img/dollar.png"),
              ),


              _signupWithFacebook(),
              _signupWithGoogle(),
              const SizedBox(
                child: Text(
                    'Or',
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),
              _signupWithEmail()
            ],
          ),
        ),
      ),
    );
  }
  Widget _signupWithFacebook() {
    return MaterialButton(
        onPressed: () {},
        minWidth: _devWidth! * 0.7,
        height: _devHegiht! * 0.06,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image:  AssetImage("assets/img/fb_btn.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(30),

          ),
          child: const Center(
            // Đảm bảo văn bản nằm ở giữa
            child: Text(
              "Sign Up with Facebook",
              style: TextStyle(
                color: Colors.white,
                // Màu chữ, nên chọn màu tương phản với background
                fontSize: 18,
                // Kích thước chữ
                fontWeight: FontWeight.bold, // Kiểu chữ
              ),
            ),
          ),
        ));
  }
  Widget _signupWithGoogle() {
    return MaterialButton(
      onPressed: () {},
      minWidth: _devWidth! * 0.7,
      height: _devHegiht! * 0.06,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image:  AssetImage("assets/img/google_btn.png"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(30),

        ),
        child: Center(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Sign Up with ",
                  style: TextStyle(
                    color: TColor.gray80,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: "G",
                  style: TextStyle(
                    color: Color(0xFF4285F4), // Màu xanh dương
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: "o",
                  style: TextStyle(
                    color:  Color(0xFFEA4335), // Màu đỏ
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: "o",
                  style:  TextStyle(
                    color: Color(0xFFFBBC05), // Màu vàng
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: "g",
                  style: TextStyle(
                    color: Color(0xFF34A853), // Màu xanh lá
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(
                  text: "le",
                  style:  TextStyle(
                    color: Color(0xFF4285F4), // Màu xanh dương
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupWithEmail() {
    return MaterialButton(
      onPressed: () {},
      color: TColor.gray70,
      minWidth: _devWidth! * 0.7,
      height: _devHegiht! * 0.06,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Thêm borderRadius
      ),
      child: Container(
        width: _devWidth!*0.85,
        height: 55,
        child: const Center(
          child: const Text(
            "Sign Up with Email",
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

}
