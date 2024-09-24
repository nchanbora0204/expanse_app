import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:money_lover/language/language_provider.dart';
import 'package:money_lover/view/setting_page/edit_screen.dart';
import 'package:money_lover/view/setting_page/forward_button.dart';
import 'package:money_lover/view/setting_page/setting_item.dart';
import 'package:money_lover/view/setting_page/setting_switch.dart';
import 'package:money_lover/view/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
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
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Ionicons.chevron_back_outline,
          ),
        ),
        leadingWidth: 80,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.setting, // Đổi sang dynamic text
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.account,
                // Đổi sang dynamic text
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/img/u1.png",
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Account",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Expense App",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ForwardButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditScreen(),
                          ),
                        );
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
              // Nút chọn ngôn ngữ
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
              SettingItem(
                title: AppLocalizations.of(context)!.notifications,
                icon: Ionicons.notifications_circle,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {},
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
                icon: Ionicons.nuclear,
                bgColor: Colors.pink.shade100,
                iconColor: Colors.pink,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
