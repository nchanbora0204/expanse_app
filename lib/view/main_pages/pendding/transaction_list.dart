import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:intl/intl.dart';
 // Đảm bảo đường dẫn chính xác đến file này


class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late Future<List<TransactionModel>> _transactionsList;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() {
    // Gọi phương thức từ TransactionService để lấy danh sách giao dịch
    _transactionsList = TransactionService().getTransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactionsList,
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
