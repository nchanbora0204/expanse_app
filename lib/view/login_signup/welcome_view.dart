import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/language/language_provider.dart';
import 'package:money_lover/view/login_signup/sign_in.dart';
import 'package:money_lover/view/login_signup/sign_up.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  _WelcomeViewState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  double? _devHeight, _devWidth;
  bool _isLogoVisible = false;
  bool _areButtonsVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _pageController = PageController();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isLogoVisible = true;
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        _controller.forward();
        setState(() {
          _areButtonsVisible = true;
        });
        _startAutoSlide();
      });
    });
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage++;
      if (_currentPage >= 3) _currentPage = 0; // Quay lại đầu khi đến cuối
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: _devWidth,
          height: _devHeight,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/img/welcome_screen.png"),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.3), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(),
                  AnimatedOpacity(
                    opacity: _isLogoVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1800),
                    child: Image.asset("assets/img/app_logo.png"),
                  ),
                  IconButton(
                      onPressed: () {
                        _showLanguageSelection();
                      },
                      icon: Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 30,
                      )),
                  SizedBox(
                    height: _devHeight! * 0.3,
                  ),
                  Expanded(
                    child: _buildPageView(),
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: _startByNew(),
                  ),
                  SlideTransition(
                    position: _offsetAnimation,
                    child: _startByAccount(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final languageProvider =
            Provider.of<LanguageProvider>(context, listen: false);
        final curLocale = languageProvider.locale.languageCode;

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('VietNam'),
                onTap: () {
                  languageProvider.setLocale(Locale('vi'));
                  Navigator.pop(context);
                },
                trailing: curLocale == 'vi'
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null,
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  languageProvider.setLocale(Locale('en'));
                  Navigator.pop(context);
                },
                trailing: curLocale == 'en'
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageView() {
    final localization = AppLocalizations.of(context)!;

    return PageView(
      controller: _pageController,
      children: [
        _buildSlide(localization.introApp, localization.feature_1_desc),
        _buildSlide(localization.feature_2_title, localization.feature_2_desc),
        _buildSlide(localization.feature_3_title, localization.feature_3_desc),
      ],
    );
  }

  Widget _buildSlide(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black54,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _startByNew() {
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(),
              ),
            );
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
              boxShadow: [
                BoxShadow(
                  color: TColor.secondary.withOpacity(0.5),
                  blurRadius: 17,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:  Center(
              child: Text(

                "ĐĂNG KÝ MIỂN PHÍ",
                style:  TextStyle(

                localization.sign_up_free,
                style: TextStyle(

                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            SizedBox(width: 4),

            const Text(
              "Đăng ký nhanh chóng",

            Text(
              localization.quick_sign_up,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _startByAccount() {
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(),
              ),
            );
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
              boxShadow: [
                BoxShadow(
                  color: TColor.secondary.withOpacity(0.5),
                  blurRadius: 17,
                  offset: Offset(0, 4),
                ),
              ],
            ),

            child: const Center(
              child: const Text(
                "ĐĂNG NHẬP",

            child: Center(
              child: Text(
                localization.login,

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const [
            const Icon(Icons.login, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            const Text(
              "Đăng nhập ngay",
          children: [
            Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            SizedBox(width: 4),
            Text(
              localization.login,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
