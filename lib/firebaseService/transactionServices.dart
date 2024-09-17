import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_lover/models/transaction_model.dart';

class TransactionService{
  final CollectionReference transactionCollection
  = FirebaseFirestore.instance.collection('transaction');
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await transactionCollection.doc(transaction.id).set(transaction.toMap());
      print("Đã thêm mới giao dịch");
    } catch (e) {
      print("Lỗi khi thêm giao dịch: $e");
    }
  }
  Future<List<TransactionModel>> getTransaction() async {
    try {
      QuerySnapshot snapshot = await transactionCollection.get();
      return snapshot.docs.map(
              (doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e, stacktrace) {
      print("Transaction Service Class : Lỗi khi lấy danh sách giao dịch: $e");
      print("Stacktrace: $stacktrace");
      return [];
    }
  }
 Future<void> updateTransaction(TransactionModel transaction) async {
   try{
     await transactionCollection.doc(transaction.id).update(transaction.toMap());
     print('cap nhat giao dich thanh cong');
   }
   catch(e){
      print('Transaction Service Class: Loi roi');
   }
 }
 Future<void> deleteTransaction(String id)async{
    try{
      await transactionCollection.doc(id).delete();
      print('xoa giao dich thanh cong');

    }
    catch(e){
      print('xoa giao dich that bai');

    }
 }

  Stream<List<TransactionModel>> getTransactionStream() {
    return transactionCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Chuyển đổi từng tài liệu thành đối tượng TransactionModel
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}