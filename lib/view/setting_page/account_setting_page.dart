import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:money_lover/firebaseService/user_services.dart';
import 'package:money_lover/language/language_provider.dart';
import 'package:money_lover/models/user_model.dart';
import 'package:money_lover/view/setting_page/edit_screen.dart';
import 'package:money_lover/view/setting_page/noitification_page.dart';
import 'package:money_lover/view/setting_page/support_page.dart';
import 'package:money_lover/view/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({Key? key}) : super(key: key);

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
        userModel = UserModel(
          uid: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          age: 0,
          gender: '',
          profileImageUrl: user.photoURL ?? '',
        );
        await userService.saveUserDetails(userModel);
      }

      setState(() {
        _user = userModel;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.samesetting),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.setting,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              _buildUserInfoCard(),
              SizedBox(height: 24),
              _buildSettingsSection(themeProvider, languageProvider, theme),
              SizedBox(height: 24),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: _user?.profileImageUrl != null && _user!.profileImageUrl.isNotEmpty
                  ? NetworkImage(_user!.profileImageUrl)
                  : AssetImage("assets/img/u1.png") as ImageProvider,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user?.name ?? "User Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _user?.email ?? "Email",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditScreen()),
                );
                if (result == true) {
                  await _loadUserData();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(ThemeProvider themeProvider, LanguageProvider languageProvider, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.language,
            title: AppLocalizations.of(context)!.language,
            trailing: Text(languageProvider.locale.languageCode == 'vi' ? "Tiếng Việt" : "English"),
            onTap: () => _showLanguagePicker(context),
          ),
          Divider(height: 1),
          _buildSettingItem(
            icon: Icons.brightness_6,
            title: AppLocalizations.of(context)!.dark_mode,
            trailing: Switch(
              value: themeProvider.curThemeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          Divider(height: 1),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: AppLocalizations.of(context)!.support,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportPage()),
              );
            },
          ),
          Divider(height: 1),
          _buildSettingItem(
            icon: Icons.notifications_none,
            title: AppLocalizations.of(context)!.notifications,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: trailing ?? Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text(AppLocalizations.of(context)!.loggingOut)
                  ],
                ),
              );
            },
          );
          try {
            await FirebaseAuth.instance.signOut();
            await Future.delayed(Duration(seconds: 3));
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, 'welcome_screen');
          } catch (e) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.logoutFailed)),
            );
          }
        },
        child: Text(
          AppLocalizations.of(context)!.logout,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
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
                title: Text('Tiếng Việt'),
                onTap: () {
                  languageProvider.setLocale(Locale('vi'));
                  Navigator.pop(context);
                },
                trailing: curLocale == 'vi'
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  languageProvider.setLocale(Locale('en'));
                  Navigator.pop(context);
                },
                trailing: curLocale == 'en'
                    ? Icon(Icons.check, color: Colors.green)
                    : null,
              )
            ],
          ),
        );
      },
    );
  }
}