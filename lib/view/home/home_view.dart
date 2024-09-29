import 'package:flutter/material.dart';
import 'package:money_lover/common_widget/custom_arc_painter.dart';
import 'package:money_lover/common_widget/segment_button.dart';
import 'package:money_lover/common_widget/status_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TransactionService _transactionService = TransactionService();
  double _totalExpense = 0.0;
  double _amountExpense = 0.0;
  double _amountIncome = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTotal();
  }

  void _fetchTotal() async {
    double amountExpense = await _transactionService.getTotalExpense();
    double amountIncome = await _transactionService.getTotalIncome();
    double total = await _transactionService.totalTrans();
    setState(() {
      _totalExpense = total;
      _amountIncome = amountIncome;
      _amountExpense = amountExpense;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _homeHeader(),
            _buildPieChart(),
            // _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  Widget _homeHeader() {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _spendingView(),
            _activeSub(),
          ],
        ),
      ),
    );
  }

  Widget _spendingView() {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatCurrency(_totalExpense),
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.monthlySpending, // Sử dụng AppLocalizations
          style: TextStyle(
            color: theme.colorScheme.onPrimary.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.onPrimary,
            foregroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(AppLocalizations.of(context)!.spendingView), // Sử dụng AppLocalizations
        ),
      ],
    );
  }

  Widget _activeSub() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatusButton(
          title: AppLocalizations.of(context)!.lowestSubs,  // Sử dụng AppLocalizations
          future: _transactionService.countTotalIncomeTransactions(),
          color: Colors.green,
        ),
        _buildStatusButton(
          title: AppLocalizations.of(context)!.highestSubs,  // Sử dụng AppLocalizations
          future: _transactionService.countTotalExpenseTransactions(),
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatusButton({
    required String title,
    required Future<int> future,
    required Color color,
  }) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                snapshot.connectionState == ConnectionState.waiting
                    ? '...'
                    : snapshot.hasError
                    ? AppLocalizations.of(context)!.errorLoadingData  // Sử dụng AppLocalizations
                    : '${snapshot.data} ${AppLocalizations.of(context)!.transactionBook}',  // Sử dụng AppLocalizations
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPieChart() {
    final theme = Theme.of(context);
    Map<String, double> dataMap = {
      AppLocalizations.of(context)!.toltalIncome: _amountIncome,  // Sử dụng AppLocalizations
      AppLocalizations.of(context)!.toltalExpense: _amountExpense,  // Sử dụng AppLocalizations
    };

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.totalExpenseOverview,  // Sử dụng AppLocalizations
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          PieChart(
            dataMap: dataMap,
            animationDuration: const Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 2.7,
            colorList: [
              theme.colorScheme.secondary,
              theme.colorScheme.error,
            ],
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            centerText: AppLocalizations.of(context)!.expenseCenterText,  // Sử dụng AppLocalizations
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: false,
              decimalPlaces: 1,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTransactionList() {
  //   return Container(
  //     margin: const EdgeInsets.all(20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           AppLocalizations.of(context)!.recentTransactions,  // Sử dụng AppLocalizations
  //           style: TextStyle(
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //             color: Theme.of(context).colorScheme.primary,
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         ListView.builder(
  //           shrinkWrap: true,
  //           physics: const NeverScrollableScrollPhysics(),
  //           itemCount: 5, // Show last 5 transactions
  //           itemBuilder: (context, index) {
  //             return ListTile(
  //               leading: CircleAvatar(
  //                 backgroundColor: index % 2 == 0 ? Colors.green : Colors.red,
  //                 child: Icon(
  //                   index % 2 == 0 ? Icons.arrow_upward : Icons.arrow_downward,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               title: Text('${AppLocalizations.of(context)!.transaction} ${index + 1}'),
  //               subtitle: Text('${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().month}/${DateTime.now().year}'),
  //               trailing: Text(
  //                 '${index % 2 == 0 ? '+' : '-'}\$${(index + 1) * 100}',
  //                 style: TextStyle(
  //                   color: index % 2 == 0 ? Colors.green : Colors.red,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
