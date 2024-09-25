import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/statistic_service.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:money_lover/view/main_pages/pendding/notification_list_page.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final TransactionService _transactionService = TransactionService();
  final StatisticService _statisticService = StatisticService();
  double _totalAmount = 0.0;
  List<double> _weeklyTotals = List.generate(2, (index) => 0.0); // 2 tuần

  @override
  void initState() {
    super.initState();
    _fetchTotalAmount();
    _fetchWeeklyTotals();
  }

  Future<void> _fetchTotalAmount() async {
    DateTime now = DateTime.now();
    _totalAmount = await _statisticService.getTotalAmountByDate(now);
    setState(() {});
  }

  Future<void> _fetchWeeklyTotals() async {
    for (int i = 0; i < 2; i++) { // Lấy tổng cho 2 tuần
      DateTime startOfWeek = DateTime.now().subtract(Duration(days: i * 7));
      _weeklyTotals[i] = await _statisticService.getTotalAmountByDate(startOfWeek);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Tổng số tiền tuần này: ${_totalAmount.toStringAsFixed(2)} VNĐ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ChartHeader(),
            TransactionBarChart(weeklyTotals: _weeklyTotals),
            TransactionListView(transactionService: _transactionService),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationListPage()),
          );
        },
        child: const Icon(Icons.notifications),
        backgroundColor: Colors.blue,
        tooltip: 'Notifications',
      ),
    );
  }
}

class ChartHeader extends StatelessWidget {
  const ChartHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Biểu đồ tổng số tiền hàng tuần',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TransactionBarChart extends StatelessWidget {
  final List<double> weeklyTotals;

  const TransactionBarChart({Key? key, required this.weeklyTotals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          barGroups: weeklyTotals.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: entry.key == 0 ? Colors.blue : Colors.orange, // Màu sắc khác nhau cho từng tuần
                  width: 40, // Độ rộng của thanh
                  borderRadius: BorderRadius.circular(5), // Bo góc thanh
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt() == 0 ? 'Tuần này' : 'Tuần trước',
                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false), // Ẩn đường biên
          gridData: FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(

              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY}\n',
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionListView extends StatelessWidget {
  final TransactionService transactionService;

  const TransactionListView({Key? key, required this.transactionService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: transactionService.getTransactionStream(), // Lấy giao dịch chi
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions available.'));
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

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Amount: ${transaction.amount.toString()}"),
        trailing: Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
        onTap: () {
          // Navigate to transaction details or allow editing
        },
      ),
    );
  }
}
