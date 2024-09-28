import 'package:flutter/material.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TransactionsPage extends StatelessWidget {
  final List<TransactionModel> transactions;

  const TransactionsPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final localizations  = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactionList),
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
