import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_lover/firebaseService/user_services.dart';
import 'package:money_lover/l10n/l10n.dart';
import 'package:money_lover/language/language_provider.dart';
import 'package:money_lover/view/home/home_view.dart';
import 'package:money_lover/view/login_signup/sign_in.dart';
import 'package:money_lover/view/login_signup/sign_up.dart';
import 'package:money_lover/view/login_signup/signup_social.dart';
import 'package:money_lover/view/login_signup/welcome_view.dart';
import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/main_pages/pendding/notification_list_page.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_analysis_page.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_list_screen.dart';
import 'package:money_lover/view/main_tab/main_tab_view.dart';
import 'package:money_lover/view/setting_page/account_setting_page.dart';
import 'package:money_lover/view/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'common/color_extension.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settingsBox');//Mở box để lưu trữ trạng thái.
  Get.put(TransactionAnalysis());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDqV2zJhaZWUIJ4s24vP9vKv2qtMOvUDFM",
      appId: "1:258938640438:android:fd4a2fcc09f074f5df2097",
      messagingSenderId: '258938640438',
      projectId: "moneylover-v1",
      storageBucket: "moneylover-v1.appspot.com",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
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
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Mooney',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: ColorScheme.fromSeed(
          seedColor: TColor.secondary,
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

      home: AuthWrapper(),
      initialRoute: 'welcome_screen',

      locale: languageProvider.locale, // Lấy locale từ LanguageProvider
      supportedLocales: L10n.all, // Xóa lặp lại supportedLocales
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      routes: {
        'account_setting': (context) => AccountSettingPage(),
        'welcome_screen': (context) => WelcomeView(),
        'sign_up': (context) => SignUp(),
        'signUp_social': (context) => SocialSignUp(),
        'sign_in': (context) => SignIn(),
        'home': (context) => HomeView(),
        'main_tab': (context) => MainTabView(),
        'detail_image_list': (context) => TransactionListPage(),

        'notifi_list_page': (context) => NotificationListPage(),

      },
    );
  }
}

// Widget để điều hướng dựa trên trạng thái đăng nhập
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Hiển thị loading trong khi kiểm tra trạng thái đăng nhập
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // Người dùng đã đăng nhập, điều hướng đến trang chính
          return MainTabView();
        } else {
          // Người dùng chưa đăng nhập, điều hướng đến trang đăng nhập
          return SignIn();
        }
      },
    );
  }
}
