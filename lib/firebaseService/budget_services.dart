import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_lover/models/budget_model.dart';

class BudgetService {
  final CollectionReference budgetCollection =
  FirebaseFirestore.instance.collection('budget');

  // Thêm một ngân sách mới
  Future<void> addBudget(BudgetModel budget) async {
    try {
      await budgetCollection.doc(budget.id).set(budget.toMap());
      print("Đã thêm mới ngân sách");
    } catch (e) {
      print("Lỗi khi thêm ngân sách: $e");
    }
  }

  // Lấy danh sách ngân sách
  Future<List<BudgetModel>> getBudgets() async {
    try {
      QuerySnapshot snapshot = await budgetCollection.get();
      return snapshot.docs.map(
            (doc) => BudgetModel.fromMap(doc.data() as Map<String, dynamic>),
      ).toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách ngân sách: $e");
      return [];
    }
  }

  // Cập nhật ngân sách
  Future<void> updateBudget(BudgetModel budget) async {
    try {
      await budgetCollection.doc(budget.id).update(budget.toMap());
      print('Cập nhật ngân sách thành công');
    } catch (e) {
      print('Lỗi khi cập nhật ngân sách: $e');
    }
  }

  // Xóa ngân sách
  Future<void> deleteBudget(String id) async {
    try {
      await budgetCollection.doc(id).delete();
      print('Xóa ngân sách thành công');
    } catch (e) {
      print('Lỗi khi xóa ngân sách: $e');
    }
  }
}
