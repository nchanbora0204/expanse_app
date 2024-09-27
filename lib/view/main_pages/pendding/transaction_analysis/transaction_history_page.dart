import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionHistoryPage extends StatelessWidget {
  final TransactionService _transactionService = TransactionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử giao dịch'),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _transactionService.getTransactionStream(), // Lấy dữ liệu từ Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có giao dịch nào.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(transaction.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Số tiền: ${transaction.amount.toString()}"),
                    trailing: Text(DateFormat('dd/MM/yyyy').format(transaction.date)),
                    onTap: () {
                      // Điều hướng đến chi tiết giao dịch nếu cần
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}