class CategoryModel {
  final String id;
  final String name;
  final int type;
  final double amount; // Thêm trường amount

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.amount, // Thêm tham số amount vào constructor
  });

  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'] ?? 'unknown_id',
      name: data['name'] ?? 'Unknown Category',
      type: data['type'] ?? 0,
      amount: data['amount']?.toDouble() ?? 0.0, // Chuyển đổi từ map
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount, // Thêm amount vào map
    };
  }
}
