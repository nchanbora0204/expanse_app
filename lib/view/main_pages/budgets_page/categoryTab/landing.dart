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
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: Text(
          localizations.budgets,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: theme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: theme.colorScheme.secondary,
              indicatorWeight: 3,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: localizations.addCategoryFormExpense,),
                Tab(text: localizations.addCategoryFormIncome),
              ],
            ),
          ),
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