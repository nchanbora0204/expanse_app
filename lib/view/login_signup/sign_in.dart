import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/firebaseService/user_services.dart';
import 'package:lottie/lottie.dart';
import 'package:money_lover/language/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  double? _devHeight, _devWidth;
  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Color> _gradientColors = [
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _gradientColors[0],
                  _gradientColors[1],
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  SizedBox(height: _devHeight! * 0.05),
                  _buildLottieAnimation(),
                  SizedBox(height: _devHeight! * 0.05),
                  _buildSignInForm(),
                  SizedBox(height: _devHeight! * 0.05),
                  _signInButton(),
                  SizedBox(height: _devHeight! * 0.02),
                  _signUpButton(),
                  SizedBox(height: _devHeight! * 0.02),
                  _facebookSignInButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/img/app_logo.png", height: 40),
        ],
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return Lottie.asset(
      'assets/animations/login_animations.json',
      height: _devHeight! * 0.3,
      fit: BoxFit.contain,
    );
  }

  Widget _buildSignInForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildTextField(AppLocalizations.of(context)!.email, _emailController, Icons.email),
          SizedBox(height: _devHeight! * 0.02),
          _buildPasswordField(AppLocalizations.of(context)!.password, _passwordController),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(icon, color: Colors.white),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String hint, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.lock, color: Colors.white),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return ElevatedButton(
      onPressed: _signInUser,
      style: ElevatedButton.styleFrom(
        foregroundColor: TColor.primary,
        backgroundColor: Colors.white,
        minimumSize: Size(_devWidth! * 0.7, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        AppLocalizations.of(context)!.signIn, // Sử dụng AppLocalizations cho nút đăng nhập
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _signUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, 'sign_up');
      },
      child: Text(
        AppLocalizations.of(context)!.signUpPrompt, // Sử dụng AppLocalizations cho nút đăng ký
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _facebookSignInButton() {
    return ElevatedButton.icon(
      icon: Image.asset("assets/img/fb.png", height: 24),
      label: Text(
        AppLocalizations.of(context)!.facebookSignIn, // Sử dụng AppLocalizations cho nút đăng nhập bằng Facebook
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: _signInWithFacebook,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[800],
        minimumSize: Size(_devWidth! * 0.7, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Future<void> _signInUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.completeInfo); // Sử dụng AppLocalizations cho thông báo lỗi
      return;
    }

    _showLoadingDialog();

    bool success = await _userService.signInWithEmailAndPassword(email, password);

    Navigator.of(context).pop(); // Close loading dialog

    if (success) {
      _showSuccessSnackBar(AppLocalizations.of(context)!.loginSuccess); // Sử dụng AppLocalizations cho thông báo thành công
      Navigator.pushNamed(context, 'main_tab');
    } else {
      _showErrorSnackBar(AppLocalizations.of(context)!.loginFailed); // Sử dụng AppLocalizations cho thông báo thất bại
    }
  }

  Future<void> _signInWithFacebook() async {
    _showLoadingDialog();
    bool success = await _userService.signInWithFacebook();
    Navigator.of(context).pop(); // Close loading dialog

    if (success) {
      _showSuccessSnackBar(AppLocalizations.of(context)!.facebookSignInSuccess);
      Navigator.pushNamed(context, 'main_tab');
    } else {
      _showErrorSnackBar(AppLocalizations.of(context)!.facebookSignInFailed);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
