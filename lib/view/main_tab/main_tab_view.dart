import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/view/main_pages/budgets_page/categoryTab/landing.dart';
import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_list.dart';
import 'package:money_lover/view/setting_page/account_setting_page.dart';
import '../home/home_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentPage = 0;
  final List<Widget> pages = [
    const HomeView(),
    TransactionList(),
    const CatTabView(),
    const AccountSettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: pages[_currentPage],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 80, // Đặt chiều cao cố định cho thanh điều hướng
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light ? Colors.white : theme.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(0, "assets/img/home.png", AppLocalizations.of(context)!.home),
              _buildIconButton(1, "assets/img/creditcards.png", AppLocalizations.of(context)!.transactionList),
              _addSpendingButton(),
              _buildIconButton(2, "assets/img/budgets.png", AppLocalizations.of(context)!.budgets),
              _buildIconButton(3, "assets/img/settings.png", AppLocalizations.of(context)!.setting),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(int index, String iconPath, String label) {
    final theme = Theme.of(context);
    final isSelected = _currentPage == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentPage = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected
                  ? (theme.brightness == Brightness.light ? Colors.black : Colors.white)
                  : theme.disabledColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? (theme.brightness == Brightness.light ? Colors.black : Colors.white)
                    : theme.disabledColor,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addSpendingButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTransactionForm(amount: '',)),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: TColor.secondary.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          "assets/img/center_btn.png",
          width: 60,
          height: 60,
        ),
      ),
    );
  }
}