import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/view/main_pages/budgets_page/categoryTab/landing.dart';

import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_list.dart';
import 'package:money_lover/view/setting_page/account_setting_page.dart';
import '../home/home_view.dart';


class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentPage = 0;
  final List<Widget> pages = [
    HomeView(),
    TransactionList(),
    CatTabView(),
    AccountSettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomBarColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: pages[_currentPage],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/img/bottom_bar_bg.png",
                color: theme.brightness == Brightness.light
                    ? Colors.white
                    : theme.scaffoldBackgroundColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(0, "assets/img/home.png"),
                  _buildIconButton(1, "assets/img/budgets.png"),
                  _addSpendingButton(), // Center button
                  _buildIconButton(2, "assets/img/calendar.png"),
                  _buildIconButton(3, "assets/img/creditcards.png"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(int index, String iconPath) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        setState(() {
          _currentPage = index;
        });
      },
      icon: Image.asset(
        iconPath,
        width: 25,
        height: 25,
        color:
        _currentPage == index
            ? (theme.brightness == Brightness.light ? Colors.black : Colors.white)
            : theme.disabledColor,
      ),
    );
  }

  Widget _addSpendingButton() {
<<<<<<< HEAD
    return Positioned(
      bottom: 20,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionForm(amount: '')), // Truyền giá trị amount mặc định (0 hoặc số khác)
          );
          // Hành động khi nhấn nút thêm chi tiêu
        },
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: TColor.secondary.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Image.asset(
            "assets/img/center_btn.png",
            width: 55,
            height: 55,
          ),
=======
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransactionForm()),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: TColor.secondary.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset(
          "assets/img/center_btn.png",
          width: 60,
          height: 60,
>>>>>>> 778538053802531a564d4dcddce9d0028f3d070d
        ),
      ),
    );
  }
}