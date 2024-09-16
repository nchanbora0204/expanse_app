// Model cho Category
class CategoryModel {
  final String id;
  final String name;


  CategoryModel({required this.id, required this.name, });

  // Chuyển từ map sang object
  factory CategoryModel.fromMap(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'] ?? 'unknown_id',  // Đảm bảo không có giá trị null
      name: data['name'] ?? 'Unknown Category',

    );
  }

  // Chuyển từ object sang map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,

    };
  }
}
