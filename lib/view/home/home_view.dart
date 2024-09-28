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
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
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

  // Phương thức để lấy tổng số tiền chi tiêu và cập nhật UI
  void _fetchTotal() async {
    double amountExpense = await _transactionService.getTotalExpense();
    double amountIncome = await _transactionService.getTotalIncome(); // Thay thế bằng ID người dùng thực tế
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

            // Pie Chart được thêm ở đây dưới header
            _buildPieChart(),

            const SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeHeader() {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.width * 1.1,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("assets/img/home_bg.png"),
          Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.05),
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.width * 0.7,
            child: CustomPaint(
              painter: CustomArcPanter(),
            ),
          ),
          _spendingView(),
          _activeSub(),
        ],
      ),
    );
  }

  String formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B'; // 1 tỷ => "1.0B"
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M'; // 1 triệu => "1.0M"
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}k'; // 1 ngàn => "1.0k"
    } else {
      return amount.toStringAsFixed(0); // Hiển thị số tiền nhỏ bình thường
    }
  }

  Widget _spendingView() {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          formatCurrency(_totalExpense).toString(), // Hiển thị tổng số tiền chi tiêu
          style: TextStyle(
            color: theme.textTheme.headlineLarge?.color,
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.monthlySpending,
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.onSecondary.withOpacity(0.15),
              ),
              color: theme.colorScheme.secondary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              AppLocalizations.of(context)!.spendingView,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _activeSub() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              // Sử dụng FutureBuilder để lấy số lượng khoản thu nhập
              Expanded(
                child: FutureBuilder<int>(
                  future: TransactionService().countTotalIncomeTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return StatusButton(
                        title: 'Khoản thu',
                        value: '...',
                        statusColor: theme.colorScheme.secondary,
                        onPressed: () {},
                      );
                    } else if (snapshot.hasError) {
                      return StatusButton(
                        title: 'Khoản thu',
                        value: 'Lỗi',
                        statusColor: theme.colorScheme.secondary,
                        onPressed: () {},
                      );
                    } else {
                      return StatusButton(
                        title: AppLocalizations.of(context)!.lowestSubs,
                        value: '${snapshot.data} khoản', // Hiển thị số lượng thu nhập
                        statusColor: theme.colorScheme.secondary,
                        onPressed: () {},
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              // Sử dụng FutureBuilder để lấy số lượng khoản chi tiêu
              Expanded(
                child: FutureBuilder<int>(
                  future: TransactionService().countTotalExpenseTransactions(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return StatusButton(
                        title: AppLocalizations.of(context)!.highestSubs,
                        value: '...',
                        statusColor: theme.colorScheme.tertiary,
                        onPressed: () {},
                      );
                    } else if (snapshot.hasError) {
                      return StatusButton(
                        title: AppLocalizations.of(context)!.highestSubs,
                        value: 'Lỗi',
                        statusColor: theme.colorScheme.tertiary,
                        onPressed: () {},
                      );
                    } else {
                      return StatusButton(
                        title: 'Khoản chi ',
                        value: '${snapshot.data} khoản', // Hiển thị số lượng chi tiêu
                        statusColor: theme.colorScheme.tertiary,
                        onPressed: () {},
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    final theme = Theme.of(context);

    Map<String, double> dataMap = {
      "Tổng thu": _amountIncome,
      "Tổng chi": _amountExpense,
    };

    return Padding(
      padding: const EdgeInsets.all(20),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        colorList: [
          theme.colorScheme.secondary,
          theme.colorScheme.tertiary,
        ],
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        centerText: "Chi tiêu",
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
    );
  }
}
