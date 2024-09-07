import 'package:flutter/material.dart';
import 'package:money_lover/view/home/home_view.dart';
import 'package:money_lover/view/login/sign_up.dart';
import 'package:money_lover/view/login/signup_social.dart';
import 'package:money_lover/view/login/welcome_view.dart';
import 'package:money_lover/view/main_tab/main_tab_view.dart';
import 'package:money_lover/view/setting_page/account_setting_page.dart';
import 'package:money_lover/view/theme_provider/theme.dart';
import 'package:money_lover/view/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

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
      theme: lightTheme,
      // Định nghĩa dartThem nếu cần
      darkTheme: ThemeData.dark(),
      // Áp dụng themeMode từ ThemeProvider
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
      //HElLO EM
   
      // home: AccountSettingPage(),
    );
  }
}
