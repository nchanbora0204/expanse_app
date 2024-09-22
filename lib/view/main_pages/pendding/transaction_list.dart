import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _transactionService.getTransactionStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return ListTile(
                  title: Text(transaction.title),
                  subtitle: Text(transaction.amount.toString()),
                  trailing: Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
                  onTap: () {
                    // Navigate to transaction details or allow editing
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
