import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:money_lover/view/main_pages/pendding/notification_list_page.dart';
// Đường dẫn đến NotificationListPage

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
        title: const Text('Transactions'),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _transactionService.getTransactionStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: const Text('No transactions available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
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
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Điều hướng đến NotificationListPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NotificationListPage() // Truyền số tiền
            ),
          ); // Qu
        },
        child: const Icon(Icons.notifications),
        backgroundColor: Colors.blue, // Màu nền cho nút
        tooltip: 'Notifications', // Tooltip cho nút
      ),
    );
  }
}
