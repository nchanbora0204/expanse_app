import 'package:cloud_firestore/cloud_firestore.dart';
class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String description;
  final String categoryId;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.description,
    required this.categoryId,
  });

  // Phương thức fromMap để chuyển đổi từ Map<String, dynamic> sang TransactionModel
  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['id'] ?? '',  // 'id' là chuỗi trong Firestore
      title: data['title']?? '',  // 'title' là chuỗi
      amount: data['amount'].toDouble() ?? '',  // 'amount' là số
      date: (data['date'] as Timestamp).toDate() ,  // 'date' là Timestamp, chuyển thành DateTime
      description: data['description']?? '' ,  // 'description' là chuỗi
      categoryId: data['categoryId']?? '',  // 'budgetId' là chuỗi
    );
  }

  // Phương thức toMap nếu bạn muốn chuyển đổi ngược lại (không bắt buộc)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),  // Chuyển DateTime thành Timestamp
      'description': description,
      'categoryId': categoryId,
    };
  }
}
