import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/view/main_pages/budgets_page/categoryTab/expense_cat_list.dart';
import 'package:money_lover/view/main_pages/budgets_page/categoryTab/income_cat_list.dart';
import 'package:money_lover/view/main_pages/budgets_page/categoryTab/landing.dart';
import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/setting_page/account_setting_page.dart';
import 'package:money_lover/view/home/home_view.dart';


class CatTabView extends StatefulWidget {
  const CatTabView({super.key});

  @override
  State<CatTabView> createState() => _CatTabView();
}

class _CatTabView extends State<CatTabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double? _devHeight, _devWidth;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: TColor.gray,
      appBar: AppBar(
        backgroundColor: TColor.gray,
        title: Image.asset(
          "assets/img/app_logo.png",
          width: _devWidth! * 0.4,
          fit: BoxFit.contain,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Khoản Chi',),
            Tab(text: 'Khoản Thu',),

          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ExpenseCatList(),
          IncomeCatList(),

        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
