class TransactionModel {
  String id;
  String title;
  double amount;
  DateTime date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
  });

  // Phương thức để chuyển đổi từ Map (Firebase) sang đối tượng Transaction
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      date: DateTime.parse(map['date']),
    );
  }

  // Phương thức để chuyển đổi từ Transaction sang Map (để lưu vào Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
