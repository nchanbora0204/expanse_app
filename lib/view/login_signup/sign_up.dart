import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/firebaseService/user_services.dart';
import 'package:money_lover/models/user_model.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import AppLocalizations

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  double? _devHeight, _devWidth;
  int _currentIndex = 0;
  bool _obscureText = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
                  _gradientColors[_currentIndex],
                  _gradientColors[(_currentIndex + 1) % _gradientColors.length],
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
                  _buildSignUpForm(),
                  SizedBox(height: _devHeight! * 0.05),
                  _signupButton(),
                  SizedBox(height: _devHeight! * 0.02),
                  _signInButton(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentIndex > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  if (_currentIndex > 0) {
                    _currentIndex--;
                    _animationController.reset();
                    _animationController.forward();
                  }
                });
              },
            )
          else
            const SizedBox(width: 48), // Placeholder for alignment
          Image.asset("assets/img/app_logo.png", height: 40),
          const SizedBox(width: 48), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _buildLottieAnimation() {
    List<String> animations = [
      'assets/animations/email_animation.json',
      'assets/animations/password_animation.json',
      'assets/animations/user_animations.json',
    ];
    return Lottie.asset(
      animations[_currentIndex],
      height: _devHeight! * 0.3,
      fit: BoxFit.contain,
    );
  }

  Widget _buildSignUpForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _buildStep(),
    );
  }

  Widget _buildStep() {
    List<Widget> steps = [
      _buildTextField(AppLocalizations.of(context)!.email, _emailController, Icons.email),
      _buildPasswordField(AppLocalizations.of(context)!.password, _passwordController),
      _buildTextField(AppLocalizations.of(context)!.name, _nameController, Icons.person),
    ];

    return Column(
      key: ValueKey<int>(_currentIndex),
      children: [
        steps[_currentIndex],
      ],
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

  Widget _signupButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_currentIndex < 2) {
          setState(() {
            _currentIndex++;
            _animationController.reset();
            _animationController.forward();
          });
        } else {
          await _registerUser();
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: TColor.primary,
        backgroundColor: Colors.white,
        minimumSize: Size(_devWidth! * 0.7, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        _currentIndex == 2 ? AppLocalizations.of(context)!.finishSignUp : AppLocalizations.of(context)!.continueText,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _signInButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, 'sign_in');
      },
      child: Text(
        AppLocalizations.of(context)!.alreadyHaveAccount,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Future<void> _registerUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.pleaseFillAllFields);
      return;
    }

    _showLoadingDialog();

    UserModel? user = await _userService.registerWithEmailAndPassword(name, email, password);

    Navigator.of(context).pop(); // Đóng dialog loading

    if (user != null) {
      _showSuccessSnackBar(AppLocalizations.of(context)!.signUpSuccess);
      Navigator.pushNamed(context, 'main_tab');
    } else {
      _showErrorSnackBar(AppLocalizations.of(context)!.signUpFailure);
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Đang Đăng Ký..."),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
