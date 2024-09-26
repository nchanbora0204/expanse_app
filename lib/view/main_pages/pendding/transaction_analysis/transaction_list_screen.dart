import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() {
    var box = Hive.box('imageValue');
    List<dynamic>? storedTransactions = box.get('imageValue', defaultValue: []);
    if (storedTransactions != null && storedTransactions.isNotEmpty) {
      setState(() {
        transactions = List<Map<String, dynamic>>.from(storedTransactions);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Giao Dịch'),
        automaticallyImplyLeading: true, // Cho phép nút "Quay lại"
      ),
      body: transactions.isEmpty
          ? Center(child: Text('Chưa có giao dịch nào.'))
          : ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                transaction['type'] == 'income' ? 'Thu Nhập' : 'Chi Tiêu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                ),
              ),
              subtitle: Text('Số tiền: ${transaction['amount']} VND'),
              trailing: Text(transaction['id']),
            ),
          );
        },
      ),
    );
  }
}