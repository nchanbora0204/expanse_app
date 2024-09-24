import 'package:flutter/material.dart';
import 'package:money_lover/models/transaction_model.dart';

class TransactionsPage extends StatelessWidget {
  final List<TransactionModel> transactions;

  TransactionsPage({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách giao dịch'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            title: Text(transaction.title),
            subtitle: Text(transaction.amount.toString()),
            trailing: Text(transaction.date.toString()),
          );
        },
      ),
    );
  }
}
