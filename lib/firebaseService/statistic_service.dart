import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_lover/models/category_model.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:intl/intl.dart';

class StatisticService {
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

  Future<double> getTotalAmountByDate(DateTime date) async {
    double totalTrans = 0.0;
    try {
      final uid = getCurrentUserId();
      if (uid == null) {
        throw Exception("Please Login First !!!");
      }

      // Tính toán ngày bắt đầu và kết thúc của tuần
      int currentWeekday = date.weekday;
      DateTime startOfWeek = date.subtract(Duration(days: currentWeekday - 1)); // Bắt đầu tuần
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59)); // Kết thúc tuần

      // Lấy giao dịch từ Category
      List<TransactionModel> transactionByWeek = [];
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('category')
          .get();

      for (var categoryDoc in categoriesSnapshot.docs) {
        final transactionSnapshot = await categoryDoc
            .reference
            .collection('transactions')
            .where('date', isGreaterThanOrEqualTo: startOfWeek)
            .where('date', isLessThanOrEqualTo: endOfWeek)
            .get();

// In ra các giao dịch tìm thấy để kiểm tra
        for (var doc in transactionSnapshot.docs) {
          print('Giao dịch: ${doc.data()}'); // In ra thông tin giao dịch
        }

        transactionByWeek.addAll(transactionSnapshot.docs.map(
                (doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>)));

        totalTrans += transactionSnapshot.docs.fold(0.0, (sum, doc) {
          double amount = doc.data()['amount']?.toDouble() ?? 0.0; // Đảm bảo lấy đúng kiểu
          return sum + amount;
        });
      }
      print('Tổng số tiền của tuần hiện tại: $totalTrans');
      return totalTrans;
    } catch (e) {
      print('Has some Error: $e');
      return 0.0;
    }
  }


  // Phương thức mới để lấy tổng số tiền hàng tuần
  Future<List<double>> getTotalWeekly(DateTime date) async {
    List<double> weeklyTotals = List.generate(7, (index) => 0.0);
    DateTime startOfWeek = date.subtract(Duration(days: date.weekday - 1)); // Thứ Hai của tuần hiện tại

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      QuerySnapshot snapshot = await _firestore
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(day))
          .where('date', isLessThan: Timestamp.fromDate(day.add(Duration(days: 1))))
          .get();

      // Tính tổng số tiền cho ngày
      double totalForDay = snapshot.docs.fold(0.0, (sum, doc) {
        TransactionModel transaction = TransactionModel.fromMap(doc.data() as Map<String, dynamic>);
        return sum + transaction.amount; // Lấy amount từ TransactionModel
      });

      weeklyTotals[i] = totalForDay; // Lưu tổng cho từng ngày
    }

    return weeklyTotals;
  }
}
