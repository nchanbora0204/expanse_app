import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_lover/common/color_extension.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  double? _devHegiht, _devWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    //ex: tam thoi an thanh dieu huong+ bar tren cung
  }

  @override
  Widget build(BuildContext context) {
    _devHegiht = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;
    

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: _devWidth,
          height: _devHegiht,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(),
                  Image.asset("assets/img/app_logo.png"),
                  SizedBox(
                    height: _devHegiht! * 0.7,
                  ),
                  _startByNew(),
                  _startByAccount()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startByNew() {
    return MaterialButton(
        onPressed: () {},
        minWidth: _devWidth! * 0.7,
        height: _devHegiht! * 0.06,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/primary_btn.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: TColor.secondary.withOpacity(0.5),
                blurRadius: 17,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            // Đảm bảo văn bản nằm ở giữa
            child: Text(
              "Cùng bắt đầu nào!",
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

  Widget _startByAccount() {
    return MaterialButton(
        onPressed: () {},
        minWidth: _devWidth! * 0.7,
        height: _devHegiht! * 0.06,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/primary_btn.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: TColor.secondary.withOpacity(0.5),
                blurRadius: 17,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            // Đảm bảo văn bản nằm ở giữa
            child: Text(
              "Tôi đã có tài khoản",
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
}
