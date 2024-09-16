import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/setting_page/account_setting_page.dart';
import '../home/home_view.dart';
import '../main_pages/budgets_page/category_list.dart';
import '../main_pages/pendding/transaction_list.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentPage = 0;
  Widget currentTabView = const HomeView();
  final List<Widget> pages = [
    HomeView(),
    TransactionList(),

    Category(),
    AccountSettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,
      body: pages[_currentPage],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/img/bottom_bar_bg.png",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentTabView = const HomeView();
                          });
                        },
                        icon: _IconButton(
                          index: 0,
                          iconPath: "assets/img/home.png",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentTabView = const HomeView();
                          });
                        },
                        icon: _IconButton(
                          index: 1,
                          iconPath: "assets/img/budgets.png",
                        ),
                      ),
                      _addSpendingButton(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentTabView = const HomeView();
                          });
                        },
                        icon: _IconButton(
                          index: 2,
                          iconPath: "assets/img/calendar.png",
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            currentTabView = const HomeView();
                          });
                        },
                        icon: _IconButton(
                          index: 3,
                          iconPath: "assets/img/creditcards.png",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _IconButton({required int index, required String iconPath}) {
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
        color: _currentPage == index ? TColor.white : TColor.gray30,
      ),
    );
  }

  Widget _addSpendingButton() {
    return Positioned(
      bottom: 20,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder:(context)=> AddTransactionForm() ));
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
        ),
      ),
    );
  }
}
