import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:money_lover/view/main_pages/pendding/notification_list_page.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_analysis_page.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionList extends StatefulWidget {
  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final TransactionService _transactionService = TransactionService();
  final TransactionAnalysis _transactionAnalysis = TransactionAnalysis();
  String _income = '';
  String _expense = '';
  String _date = '';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Hàm để khôi phục trạng thái từ SharedPreferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedIncome = prefs.getString('savedIncome');
    String? savedExpense = prefs.getString('savedExpense');
    String? savedDate = prefs.getString('savedDate');

    setState(() {
      _income = savedIncome ?? '';
      _expense = savedExpense ?? '';
      _date = savedDate ?? '';
    });

    print("Loaded Income: $_income, Expense: $_expense, Date: $_date");
  }

  // Hàm để lưu dữ liệu vào SharedPreferences
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

  // Hàm để chọn ảnh từ thư viện và lưu trạng thái vào SharedPreferences
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Nhận diện văn bản từ ảnh
      String recognizedText = await _transactionAnalysis
          .recognizeTextFromImage(File(pickedFile.path));
      // Phân tích thu nhập và chi tiêu
      Map<String, String> result =
          _transactionAnalysis.analyzeTransaction(recognizedText);

      DateTime now = DateTime.now();

      await _saveTransactionData(
          result['income'] ?? '', result['expense'] ?? '', now);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết Giao Dịch'),
      ),
      body: Column(
        children: [
          if (_income.isNotEmpty || _expense.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Kết quả phân tích từ ảnh:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  if (_income.isNotEmpty)
                    Text('Vừa Nhận: $_income',
                        style: TextStyle(color: Colors.green)),
                  if (_expense.isNotEmpty)
                    Text('Vừa chi: $_expense',
                        style: TextStyle(color: Colors.red)),
                  if (_date.isNotEmpty)
                    Text("Ngày: $_date",
                        style: TextStyle(color: Colors.blueAccent)),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
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
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: ListTile(
                          title: Text(transaction.title,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle:
                              Text("Amount: ${transaction.amount.toString()}"),
                          trailing: Text(DateFormat('dd/MM/yyyy')
                              .format(transaction.date)),
                          onTap: () {
                            // Điều hướng đến chi tiết giao dịch hoặc chỉnh sửa
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationListPage()),
              );
            },
            child: Icon(Icons.notifications),
            backgroundColor: Colors.blue,
            tooltip: 'Notifications',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _pickImage,
            child: Icon(Icons.photo_library),
            backgroundColor: Colors.green,
            tooltip: 'Chọn ảnh từ thư viện',
          ),
          SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionHistoryPage()),
              );
            },
            child: Icon(Icons.history),
            backgroundColor: Colors.orange,
            tooltip: 'Lịch sử giao dịch',
          ),
        ],
      ),
    );
  }
}
