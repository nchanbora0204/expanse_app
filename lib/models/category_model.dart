// Model cho Category

class CategoryModel {
  final String id;
  final String name;
  final int type; // 0: khoản chi, 1: khoản thu
  final double amount; // Số tiền dự định chi

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.amount,
  });

  // Chuyển từ map sang object
  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'] ?? 'unknown_id',
      name: data['name'] ?? 'Unknown Category',
      type: data['type'] ?? 0,
      amount: data['amount']?.toDouble() ?? 0.0,
    );
  }

  // Chuyển từ object sang map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
    };
  }
}
