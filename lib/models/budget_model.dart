import 'package:money_lover/view/main_pages/budgets_page/categoryTab/income_cat_list.dart';

class BudgetModel {
  final String id;
  final String tittle;
  final double amount;
  final DateTime date;
  BudgetModel({
    required this.id,
    required this.tittle,
    required this.amount,
    required this.date
});
  // Firebase Data => đối tượng Budget
  factory BudgetModel.fromMap(Map<String, dynamic> map){
    return BudgetModel(
        id: map['id']?? '',
        tittle: map['tittle'] ?? '',
        amount: map['amount']?.toDouble() ?? 0.0,
        date: DateTime.parse(map['date']),
    );
  }
  // Đối tượng Budget => Firebase Data
  Map<String, dynamic> toMap(){
    return {
      'id':id,
      'tittle': tittle,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}