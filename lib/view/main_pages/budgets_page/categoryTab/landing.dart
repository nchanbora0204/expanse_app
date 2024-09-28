import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/view/main_pages/budgets_page/categoryTab/expense_cat_list.dart';
import 'package:money_lover/view/main_pages/budgets_page/categoryTab/income_cat_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    _tabController = TabController(length: 2, vsync: this); // Thay đổi length thành 2
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

    final localizations = AppLocalizations.of(context)!;

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
          tabs: [
            Tab(text: localizations.addCategoryFormExpense), // Sử dụng chuỗi dịch
            Tab(text: localizations.addCategoryFormIncome),    // Sử dụng chuỗi dịch
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
