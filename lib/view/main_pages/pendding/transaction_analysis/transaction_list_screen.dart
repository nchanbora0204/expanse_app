import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_analysis/transaction_analysis_page.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_list.dart';
import 'package:money_lover/view/main_tab/main_tab_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Thêm dòng này

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
      Get.snackbar(AppLocalizations.of(Get.context!)!.confirmDelete, AppLocalizations.of(Get.context!)!.confirmDeleteMessage,
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
          title: Text(AppLocalizations.of(context)!.confirmDelete),
          content: Text(AppLocalizations.of(context)!.confirmDeleteMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await Future.delayed(Duration(milliseconds: 500));

      transactions.removeAt(index);
      await saveTransactions();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactionList),
        centerTitle: true,
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
            ? Center(child: Text(AppLocalizations.of(context)!.noTransactions))
            : ListView.builder(
          itemCount: uniqueTransactions.length,
          itemBuilder: (context, index) {
            final transaction = uniqueTransactions[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: GestureDetector(
                onLongPress: () {
                  deleteTransaction(index);
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
                        '${AppLocalizations.of(context)!.amount}: ${NumberFormat('#,###').format(transaction['amount'])} VND',
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
