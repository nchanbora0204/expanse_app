import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:money_lover/firebaseService/user_services.dart';
import 'package:money_lover/language/language_provider.dart';
import 'package:money_lover/models/user_model.dart';
import 'package:money_lover/view/setting_page/edit_screen.dart';
import 'package:money_lover/view/setting_page/forward_button.dart';
import 'package:money_lover/view/setting_page/noitification_page.dart';
import 'package:money_lover/view/setting_page/setting_item.dart';
import 'package:money_lover/view/setting_page/setting_switch.dart';
import 'package:money_lover/view/setting_page/support_page.dart';
import 'package:money_lover/view/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _loading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserService userService = UserService();
      UserModel? userModel = await userService.getUserDetails(user.uid);

      if (userModel == null) {
        // Nếu không tìm thấy dữ liệu người dùng, tạo một UserModel mới từ thông tin hiện có
        userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          age: 0,
          gender: '',
          profileImageUrl: user.photoURL ?? '',
        );
        // Lưu thông tin người dùng mới vào Firestore
        await userService.saveUserDetails(userModel);
      }

      setState(() {
        _user = userModel;
        _loading = false;
        print(_user);
      });
    }
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final curLocale = languageProvider.locale.languageCode;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('VietNam'),
                onTap: () {
                  languageProvider.setLocale(const Locale('vi'));
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
                title: const Text('English'),
                onTap: () {
                  languageProvider.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
                trailing: curLocale == 'en'
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentMode = themeProvider.curThemeMode;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.samesetting),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.setting,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.account,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          _user?.profileImageUrl != null &&
                                  _user!.profileImageUrl.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    _user!.profileImageUrl,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/img/u1.png",
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                )
                              : ClipOval(
                                  child: Image.asset(
                                    "assets/img/u1.png",
                                    width: 70,
                                    height: 70,
                                  ),
                                ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _user?.name ?? "User Name",
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                _user?.email ?? "Email",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ForwardButton(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditScreen(),
                                ),
                              );
                              if (result == true) {
                                await _loadUserData();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
              const SizedBox(height: 60),
              Text(
                AppLocalizations.of(context)!.samesetting,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              SettingItem(
                title: AppLocalizations.of(context)!.language,
                icon: Ionicons.earth,
                bgColor: Colors.orange.shade100,
                iconColor: Colors.orange,
                value: languageProvider.locale.languageCode == 'vi'
                    ? "VietNam"
                    : "English",
                onTap: () {
                  _showLanguagePicker(context);
                },
                showDropdown: true,
              ),
              const SizedBox(height: 50),
              SettingSwitch(
                title: AppLocalizations.of(context)!.dark_mode,
                icon: Ionicons.moon,
                bgColor: Colors.purple.shade100,
                iconColor: Colors.purple,
                currentMode: currentMode,
                onModeChange: (mode) {
                  themeProvider.setThemeMode(mode);
                },
                onSystemModeTap: () {
                  themeProvider.setThemeMode(ThemeMode.system);
                },
              ),
              const SizedBox(height: 50),
              SettingItem(
                title: AppLocalizations.of(context)!.support,
                icon: Ionicons.help_circle,
                bgColor: Colors.pink.shade100,
                iconColor: Colors.pink,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportPage()),
                  );
                },
                showDropdown: false,
              ),
              const SizedBox(height: 50),
              SettingItem(
                title: AppLocalizations.of(context)!.notifications,
                icon: Ionicons.notifications_circle,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationSettingsPage(),
                    ),
                  );
                },
                showDropdown: false,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Row(
                          children: <Widget>[
                            const CircularProgressIndicator(),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(AppLocalizations.of(context)!.loggingOut)
                          ],
                        ),
                      );
                    },
                  );
                  try {
                    await FirebaseAuth.instance.signOut();
                    await Future.delayed(const Duration(seconds: 3));
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, 'welcome_screen');
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.logoutFailed)),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.logout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
