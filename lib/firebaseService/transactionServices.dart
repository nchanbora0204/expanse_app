import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_lover/models/transaction_model.dart';

class TransactionService {
  // Lấy userId của người dùng hiện tại
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Truy cập collection transaction của từng người dùng
  CollectionReference get transactionCollection {
    if (userId == null) {
      throw Exception("Chưa đăng nhập, không thể truy cập giao dịch.");
    }
    return FirebaseFirestore.instance.collection('users').doc(userId).collection('transactions');
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Thêm giao dịch mới
  Future<void> addTransaction(TransactionModel transaction) async {
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
          .doc(transaction.categoryId) // Document ID là categoryId
          .collection('transactions') // Subcollection cho các giao dịch
          .doc(transaction.id)
          .set(transaction.toMap());
      print('Thêm mới giao dịch thành công');
    } catch (e) {
      print('Lỗi khi thêm mới giao dịch: $e');
    }
  }

  // Lấy danh sách giao dịch
  Future<List<TransactionModel>> getTransaction() async {
    try {
      QuerySnapshot snapshot = await transactionCollection.get();
      return snapshot.docs.map(
              (doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e, stacktrace) {
      print("Transaction Service Class: Lỗi khi lấy danh sách giao dịch: $e");
      print("Stacktrace: $stacktrace");
      return [];
    }
  }

  // Cập nhật giao dịch
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await transactionCollection.doc(transaction.id).update(transaction.toMap());
      print('Cập nhật giao dịch thành công');
    } catch (e) {
      print('Transaction Service Class: Lỗi khi cập nhật giao dịch: $e');
    }
  }

  // Xóa giao dịch
  Future<void> deleteTransaction(String id) async {
    try {
      await transactionCollection.doc(id).delete();
      print('Xóa giao dịch thành công');
    } catch (e) {
      print('Transaction Service Class: Lỗi khi xóa giao dịch: $e');
    }
  }

  // Lấy dữ liệu theo dạng Stream để cập nhật real-time
  Stream<List<TransactionModel>> getTransactionStream() {
    final uid = getCurrentUserId();
    if (uid == null) {
      throw Exception("Chưa đăng nhập, không thể truy cập giao dịch.");
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('category')
        .snapshots()
        .asyncMap((categoriesSnapshot) async {
      List<TransactionModel> transactions = [];
      for (var categoryDoc in categoriesSnapshot.docs) {
        final transactionsSnapshot = await categoryDoc.reference
            .collection('transactions')
            .get();
        transactions.addAll(transactionsSnapshot.docs.map((doc) =>
            TransactionModel.fromMap(doc.data())));
      }
      return transactions;
    });
  }

  Future<double> totalTrans() async {
    String? uid = getCurrentUserId();
    if (uid == null) {
      throw Exception("Chưa đăng nhập, không thể truy cập giao dịch.");
    }

    double totalExpanse = 0.0;
    try {

      QuerySnapshot categorySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('category')
          .where('type', isEqualTo: 0) // Lọc category có type = 0 (thu nhập)
          .get();

      // Duyệt qua từng category có type = 0
      for (var categoryDoc in categorySnapshot.docs) {
        // Truy cập subcollection transactions để lấy các giao dịch của category này
        QuerySnapshot transactionSnapshot = await categoryDoc.reference
            .collection('transactions')
            .get();

        // Cộng dồn tổng số tiền của các giao dịch
        for (var transaction in transactionSnapshot.docs) {
          totalExpanse += (transaction['amount'] as num).toDouble();
        }
      }
    } catch (e) {
      print("Lỗi khi tính tổng thu nhập: $e");
    }
    return totalExpanse;
  }
  Future<int> countTotalIncomeTransactions() async {
    String? uid = getCurrentUserId();
    try {
      final uid = getCurrentUserId();
      if (uid == null) {
        print("Chưa có người dùng đăng nhập.");
        return 0;
      }

      // Truy vấn tất cả các giao dịch có type = 0 (Income)
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('category')
          .where('type', isEqualTo: 0) // Loại thu nhập (Income)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Lỗi khi tính tổng số lượng thu nhập: $e');
      return 0;
    }
  }

  // Hàm đếm tổng số lượng các giao dịch là chi tiêu (Expense) - type = 1
  Future<int> countTotalExpenseTransactions() async {
    try {
      final uid = getCurrentUserId();
      if (uid == null) {
        print("Chưa có người dùng đăng nhập.");
        return 0;
      }

      // Truy vấn tất cả các giao dịch có type = 1 (Expense)
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('category')
          .where('type', isEqualTo: 1) // Loại chi tiêu (Expense)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Lỗi khi tính tổng số lượng chi tiêu: $e');
      return 0;
    }
  }
  Future<double> getTotalExpense() async {
    String? uid = getCurrentUserId();
    double totalExpense = 0.0;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('category')
          .where('type', isEqualTo: 0) // Loại chi tiêu (Expense)
          .get();

      for (var doc in snapshot.docs) {
        totalExpense += (doc['amount'] as num).toDouble();
      }
      print('blublub: $totalExpense' );
    } catch (e) {
      print('Lỗi khi tính tổng chi tiêu: $e');
    }
    return totalExpense;
  }
  Future<double> getTotalIncome() async {
    String? uid = getCurrentUserId();
    double totalIncome = 0.0;
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('category')
          .where('type', isEqualTo: 1) // Loại chi tiêu (Expense)
          .get();


      for (var doc in snapshot.docs) {
        totalIncome += (doc['amount'] as num).toDouble();
      }
      print('blabla: $totalIncome' );
    } catch (e) {
      print('Lỗi khi tính tổng thu nhập: $e');
    }
    return totalIncome;
  }
}