import 'dart:io';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_lover/firebaseService/transaction_hunter.dart';
import 'package:money_lover/firebaseService/statistic_service.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:money_lover/view/main_pages/pendding/notification_list_page.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_analysis_page.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final TransactionService _transactionService = TransactionService();
  late final TransactionAnalysis _transactionAnalysis;
  final StatisticService _statisticService = StatisticService();
  final HunterService _hunterService = HunterService();
  double _totalAmount = 0.0;
  final List<double> _weeklyTotals = List.generate(2, (index) => 0.0);
  String _income = '';
  String _expense = '';
  String _date = '';

  @override
  void initState() {
    super.initState();
    _transactionAnalysis = Get.put(TransactionAnalysis());
    _loadSavedData();
    _fetchTotalAmount();
    _fetchWeeklyTotals();
  }

  Future<void> _fetchTotalAmount() async {
    DateTime now = DateTime.now();
    double? total = await _statisticService.getTotalAmountByDate(now);
    if (total != null) {
      _totalAmount = total;
    }
    setState(() {});
  }

  Future<void> _fetchWeeklyTotals() async {
    for (int i = 0; i < 2; i++) {
      // Lấy tổng cho 2 tuần
      DateTime startOfWeek = DateTime.now().subtract(Duration(days: i * 7));
      double? total = await _statisticService.getTotalAmountByDate(startOfWeek);
      if (total != null) {
        _weeklyTotals[i] = total;
      }
    }
    setState(() {});
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _income = prefs.getString('savedIncome') ?? '';
      _expense = prefs.getString('savedExpense') ?? '';
      _date = prefs.getString('savedDate') ?? '';
    });
    print("Loaded Income: $_income, Expense: $_expense, Date: $_date");
  }

  Future<void> _saveTransactionData(
      String income, String expense, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedIncome', income);
    await prefs.setString('savedExpense', expense);
    await prefs.setString('savedDate', DateFormat('dd/MM/yyyy').format(date));

    setState(() {
      _income = income;
      _expense = expense;
      _date = DateFormat('dd/MM/yyyy').format(date);
    });

    print("Saved Income: $_income, Expense: $_expense, Date: $_date");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Builder(
                builder: (BuildContext context) {
                  final localization = AppLocalizations.of(context);
                  // if (localization == null) {
                  //   return Text('Transaction Book'); // Giá trị mặc định
                  // }
                  final brightness = Theme.of(context).brightness;

                  final isDarkMode = brightness == Brightness.dark;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [Colors.grey[600]!, Colors.grey[900]!]
                            : [Colors.blue[300]!, Colors.blue[700]!],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.totalThisWeek,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            '${(_totalAmount ?? 0).toStringAsFixed(2)} VNĐ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            AppLocalizations.of(context)!.transactionBook,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.chartHeader,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      AspectRatio(
                        aspectRatio: 1.7,
                        child: TransactionBarChart(weeklyTotals: _weeklyTotals),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return TransactionListView(
                    transactionService: _transactionService);
              },
              childCount: 1,
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFloatingActionButton(),
    );
  }
}

class TransactionBarChart extends StatelessWidget {
  final List<double> weeklyTotals;

  const TransactionBarChart({Key? key, required this.weeklyTotals})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: weeklyTotals.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.blue.shade700],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    value.toInt() == 0
                        ? AppLocalizations.of(context)!.thisWeek
                        : AppLocalizations.of(context)!.lastWeek,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(2)} VNĐ',
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TransactionListView extends StatelessWidget {
  final TransactionService transactionService;

  const TransactionListView({Key? key, required this.transactionService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: transactionService.getTransactionStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No transactions available.'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final transaction = snapshot.data![index];
              return TransactionCard(transaction: transaction);
            },
          );
        }
      },
    );
  }
}

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: transaction.amount >= 0 ? Colors.green : Colors.red,
          child: Icon(
            transaction.amount >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
        title: Text(
          transaction.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          DateFormat('dd/MM/yyyy').format(transaction.date),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Text(
          '${transaction.amount.toStringAsFixed(2)} VNĐ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: transaction.amount >= 0 ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}

class AnimatedFloatingActionButton extends StatefulWidget {
  @override
  _AnimatedFloatingActionButtonState createState() =>
      _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState
    extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isExpanded = !isExpanded;
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationListPage()),
              );
            },
            tooltip: 'Notifications',
            child: Icon(Icons.notifications),
            heroTag: 'btn1',
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: FloatingActionButton(
            onPressed: () async {
              await Get.find<TransactionAnalysis>().pickImage();
            },
            tooltip: 'Pick Image',
            child: Icon(Icons.photo_library),
            heroTag: 'btn2',
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionListPage()),
              );
            },
            tooltip: 'Add Transaction',
            child: Icon(Icons.add),
            heroTag: 'btn3',
          ),
        ),
        FloatingActionButton(
          onPressed: animate,
          tooltip: 'Toggle',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animateIcon,
          ),
          heroTag: 'btn4',
        ),
      ],
    );
  }
}
