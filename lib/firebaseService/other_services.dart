import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_lover/models/category_model.dart';
import 'package:money_lover/models/transaction_model.dart';

class CategoryService {
  final CollectionReference categoryCollection = FirebaseFirestore.instance.collection('category');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy user ID hiện tại
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Lấy danh sách category cho user hiện tại
  Future<List<CategoryModel>> getCategory() async {
    String? uid = getCurrentUserId();
    if (uid == null) {
      print("Chưa có người dùng đăng nhập.");
      return [];
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('category') // Subcollection for user's categories
          .get();
      return snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e, stacktrace) {
      print("Category Service Class: Lỗi khi lấy danh sách category: $e");
      print("Stacktrace: $stacktrace");
      return [];
    }
  }

  // Thêm category mới cho user hiện tại
  Future<void> addCategory(CategoryModel category) async {
    String? uid = getCurrentUserId();
    if (uid == null) {
      print("Chưa có người dùng đăng nhập.");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(category.id)
          .set(category.toMap());
      print('Category Service Class: Thêm mới thành công');

    } catch (e) {
      print('Category Service Class: Lỗi khi thêm mới Category: $e');
    }
  }

  // Cập nhật category cho user hiện tại
  Future<void> updateCategory(CategoryModel category) async {
    String? uid = getCurrentUserId();
    if (uid == null) {
      print("Chưa có người dùng đăng nhập.");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(category.id)
          .update(category.toMap());
      print('Cập nhật category thành công');
    } catch (e) {
      print('Category Service Class: Lỗi khi cập nhật Category');
    }
  }

  // Lấy danh sách category theo type
  Future<List<CategoryModel>> getCategoriesByType(int type) async {
    String? uid = getCurrentUserId();
    if (uid == null) {
      print("Chưa có người dùng đăng nhập.");
      return [];
    }

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('category')
          .where('type', isEqualTo: type)
          .get();

      return snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Category Service Class: Lỗi khi lấy danh sách category theo type: $e");
      return [];
    }
  }

  // Lấy danh sách category có type là 0 (khoản chi)
  Future<List<CategoryModel>> getCategoriesForExpenses() async {
    return await getCategoriesByType(0);
  }

  // Lấy danh sách category có type là 1 (khoản thu)
  Future<List<CategoryModel>> getCategoriesForIncome() async {
    return await getCategoriesByType(1);
  }

  // Stream danh sách category cho user hiện tại
  Stream<List<CategoryModel>> getCategoryStream() {
    String? uid = getCurrentUserId();
    if (uid == null) {
      print("Chưa có người dùng đăng nhập.");
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('category')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Lấy danh sách các giao dịch theo categoryId cho user hiện tại
  Future<List<TransactionModel>> getTransactionsByCategory(String categoryId) async {
    String? uid = getCurrentUserId();
    if (uid == null) {
      print("Chưa có người dùng đăng nhập.");
      return [];
    }

    try {
      // Lấy danh sách giao dịch từ subcollection của categoryId
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('category') // Collection chứa các category
          .doc(categoryId) // Document ID là categoryId
          .collection('transactions') // Subcollection chứa các giao dịch
          .get();

      print("Giao dịch lấy được: ${snapshot.docs.length}"); // Debug log

      // Chuyển đổi các document thành danh sách TransactionModel
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Lỗi khi lấy danh sách giao dịch theo categoryId: $e");
      return [];
    }
  }
}
