class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String description;
  final String budgetId;


  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.description,
    required this.budgetId,
  });

  // Phương thức để chuyển đổi từ Map (Firebase) sang đối tượng Transaction
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date']),
      description: map['description'],
      budgetId: map['budgetId'],
    );
  }

  // Phương thức để chuyển đổi từ Transaction sang Map (để lưu vào Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': description,
      'budgetId': budgetId,
    };
  }
}
