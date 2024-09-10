import 'package:flutter/material.dart';
import 'package:money_lover/view/home/home_view.dart';
import 'package:money_lover/view/login/sign_up.dart';
import 'package:money_lover/view/login/signup_social.dart';
import 'package:money_lover/view/login/welcome_view.dart';
import 'package:money_lover/view/main_tab/main_tab_view.dart';
import 'package:money_lover/view/setting_page/account_setting_page.dart';
import 'package:money_lover/view/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'common/color_extension.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeMode = themeProvider.curThemeMode;

    return MaterialApp(
      title: 'Mooney',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.primary,
          background: TColor.gray80,
          primary: TColor.gray70,
          primaryContainer: TColor.gray60,
          secondary: TColor.secondary,
        ),
        useMaterial3: false,
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: Colors.black, fontSize: 36),
          headlineMedium: TextStyle(color: Colors.black, fontSize: 27),
          headlineSmall: TextStyle(color: Colors.black, fontSize: 24),
          bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: Colors.white, fontSize: 36),
          headlineMedium: TextStyle(color: Colors.white, fontSize: 27),
          headlineSmall: TextStyle(color: Colors.white, fontSize: 24),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      themeMode: themeMode,
      initialRoute: 'main_tab',
      routes: {
        'account_setting': (context) => AccountSettingPage(),
        'welcome_screen': (context) => WelcomeView(),
        'sign_up': (context) => SignUp(),
        'signUp_social': (context) => SocialSignUp(),
        'home': (context) => HomeView(),
        'main_tab': (context) => MainTabView(),
      },
    );
  }
}
