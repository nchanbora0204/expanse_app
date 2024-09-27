import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_analysis_page.dart';
import 'package:money_lover/view/main_tab/main_tab_view.dart';

class TransactionListPage extends StatelessWidget {
  final RxList<Map<String, dynamic>> transactions = <Map<String, dynamic>>[].obs;
  final TransactionAnalysis transactionAnalysis = Get.put(TransactionAnalysis());

  TransactionListPage() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      var box = await Hive.openBox('transactions');
      List<dynamic>? storedTransactions = box.get('transactionList');
      if (storedTransactions != null) {
        transactions.value = List<Map<String, dynamic>>.from(storedTransactions);
      }
    } catch (e) {
      print('Error loading transactions: $e');
      Get.snackbar('Error', 'Failed to load transactions',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveTransactions() async {
    try {
      var box = await Hive.openBox('transactions');
      await box.put('transactionList', transactions.toList());
    } catch (e) {
      print('Error saving transactions: $e');
      Get.snackbar('Error', 'Failed to save transactions',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void addNewTransaction(Map<String, dynamic> newTransaction) {
    transactions.add(newTransaction);
    saveTransactions();
  }

  Future<void> deleteTransaction(int index) async {
    bool? shouldDelete = await showDialog<bool>(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác Nhận'),
          content: Text('Bạn có chắc chắn muốn xóa giao dịch này không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Đồng Ý'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Không Đồng Ý'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      // Hiển thị loading trước khi xóa
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Thực hiện việc xóa giao dịch
      await Future.delayed(Duration(milliseconds: 500)); // Thêm một độ trễ giả lập để thấy hiệu ứng loading

      transactions.removeAt(index); // Xóa giao dịch khỏi danh sách
      await saveTransactions(); // Lưu lại trạng thái hiện tại
      Get.back(); // Đóng hộp thoại loading
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc muốn xóa giao dịch này không?'),
          actions: [
            TextButton(
              child: Text('Không đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Đồng ý'),
              onPressed: () {
                // Gọi hàm xóa giao dịch trực tiếp
                deleteTransaction(index);
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Giao Dịch'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainTabView()),
          ),
        ),
      ),
      body: Obx(() {
        final allTransactions = transactionAnalysis.analyzedTransactions.isNotEmpty
            ? transactionAnalysis.analyzedTransactions
            : transactions;

        final uniqueTransactions = allTransactions.toSet().toList();

        return uniqueTransactions.isEmpty
            ? Center(child: Text('Chưa có giao dịch nào.'))
            : ListView.builder(
          itemCount: uniqueTransactions.length,
          itemBuilder: (context, index) {
            final transaction = uniqueTransactions[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: GestureDetector(
                onLongPress: () {
                  _showDeleteConfirmationDialog(context, index);
                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTransactionForm(
                          amount: transaction['amount'].toString(),
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'transaction_${transaction['id']}',
                    child: ListTile(
                      title: Text(
                        transaction['type'] == 'income' ? 'Thu Nhập' : 'Chi Tiêu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaction['type'] == 'income' ? Colors.green : Colors.red,
                        ),
                      ),
                      subtitle: Text(
                        'Số tiền: ${NumberFormat('#,###').format(transaction['amount'])} VND',
                      ),
                      trailing: Text(DateFormat('dd/MM/yyyy').format(DateTime.now())),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
