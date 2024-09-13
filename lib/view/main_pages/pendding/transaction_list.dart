import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/models/transaction_model.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {


  double? _devHeight, _devWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Image.asset(
          "assets/img/app_logo.png",
          width: _devWidth! * 0.4,
          fit: BoxFit.contain,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _transactionList(),
          // ElevatedButton(
          //   onPressed: () async {
          //     final result = await Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AddTransactionForm()),
          //     );
          //     if (result != null) {
          //       _addTransaction(result as Transaction);
          //     }
          //   },
          //   child: Text('Thêm Giao Dịch'),
          //   style: ElevatedButton.styleFrom(
          //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _transactionList() {
    final theme = Theme.of(context);
    return Expanded(
      child: ListView.builder(
        itemCount: null,
        itemBuilder: (context, index) {
          final transaction = null;
          return ListTile(
            title: Text(
              transaction.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            subtitle: Text(
              'Số tiền: ${transaction.amount.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            onTap: () {
              // Xử lý sự kiện nhấn vào đây
              print('Nhấn vào giao dịch: ${transaction.title}');
            },
          );
        },
      ),
    );
  }
}
