import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String categoryId;
  final String description;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.description,
  });

  // Chuyển từ map sang object
  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      id: data['id'] ?? 'unknown_id',
      title: data['title'] ?? 'Unknown Title',
      amount: data['amount']?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp).toDate(),
      categoryId: data['categoryId'] ?? 'unknown_category',
      description: data['description'] ?? '',
    );
  }

  // Chuyển từ object sang map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'categoryId': categoryId,
      'description': description,
    };
  }
}