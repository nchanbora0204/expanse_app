import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:money_lover/view/setting_page/edit_screen.dart';
import 'package:money_lover/view/setting_page/forward_button.dart';
import 'package:money_lover/view/setting_page/setting_item.dart';
import 'package:money_lover/view/setting_page/setting_switch.dart';
import 'package:money_lover/view/theme_provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../common/color_extension.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.curThemeMode == ThemeMode.dark;

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
                "Cài Đặt",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                "Tài Khoản",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/img/u1.png",
                      width: 70,
                      height: 70,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Account",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Expense App",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,

                          ),
                        )
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
              const SizedBox(
                height: 60,
              ),
              Text(
                "Cài Đặt",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 27,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SettingItem(
                title: "Ngôn Ngữ",
                icon: Ionicons.earth,
                bgColor: Colors.orange.shade100,
                iconColor: Colors.orange,
                value: "Viet",
                onTap: () {},
              ),
              const SizedBox(
                height: 50,
              ),
              SettingItem(
                title: "Thông Báo ",
                icon: Ionicons.notifications_circle,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {},
              ),
              const SizedBox(
                height: 50,
              ),
              SettingSwitch(
                title: "Chế Độ Hiển Thị",
                icon: Ionicons.moon,
                bgColor: Colors.purple.shade100,
                iconColor: Colors.purple,
                value: isDarkMode,
                onTap: (value) {
                  // setState(() {
                  //   isDarkMode = value;
                  // });
                  themeProvider.toggleTheme(value);
                },
              ),
              const SizedBox(
                height: 50,
              ),
              SettingItem(
                title: "Hổ Trợ",
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
