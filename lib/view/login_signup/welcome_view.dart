import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/language/language_provider.dart';
import 'package:money_lover/view/login_signup/sign_in.dart';
import 'package:money_lover/view/login_signup/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

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

  final List<Color> _gradientColors = [
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.yellow,
  ];

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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
  void _showLanguageSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
        final curLocale = languageProvider.locale.languageCode;

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tiếng Việt'),
                onTap: () {
                  languageProvider.setLocale(const Locale('vi'));
                  Navigator.pop(context);
                },
                trailing: curLocale == 'vi'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  languageProvider.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
                trailing: curLocale == 'en'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              ),
            ],
          ),
        );
      },
    );
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
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _gradientColors[_currentPage],
                  _gradientColors[(_currentPage + 1) % _gradientColors.length],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                Expanded(child: _buildPageView()),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedOpacity(
            opacity: _isLogoVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1800),
            child: Image.asset("assets/img/app_logo.png", height: 50),
          ),
          IconButton(
            onPressed: _showLanguageSelection,
            icon: const Icon(Icons.language, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    final localization = AppLocalizations.of(context)!;
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        _buildSlide(
          localization.introApp,
          localization.feature_1_desc,
          'assets/animations/money_management.json',
        ),
        _buildSlide(
          localization.feature_2_title,
          localization.feature_2_desc,
          'assets/animations/budget_planning.json',
        ),
        _buildSlide(
          localization.feature_3_title,
          localization.feature_3_desc,
          'assets/animations/data_analys.json',
        ),
      ],
    );
  }

  Widget _buildSlide(String title, String description, String animationAsset) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          animationAsset,
          height: _devHeight! * 0.3,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        _buildPageIndicator(),
        const SizedBox(height: 20),
        SlideTransition(
          position: _offsetAnimation,
          child: _startByNew(),
        ),
        const SizedBox(height: 10),
        SlideTransition(
          position: _offsetAnimation,
          child: _startByAccount(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.4),
          ),
        );
      }),
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
            child: Center(
              child: Text(
                localization.sign_up_free,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              localization.quick_sign_up,
              style: const TextStyle(color: Colors.white),
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
            child: Center(
              child: Text(
                localization.login,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              localization.login,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
