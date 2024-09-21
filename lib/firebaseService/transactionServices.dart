
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_lover/models/transaction_model.dart';

class TransactionService{
  final CollectionReference transactionColection
  = FirebaseFirestore.instance.collection('transaction');
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await transactionColection.doc(transaction.id).set(transaction.toMap());
      print("Đã thêm mới giao dịch");
    } catch (e) {
      print("Lỗi khi thêm giao dịch: $e");
    }
  }
 Future<List<TransactionModel>> getTransaction() async{
    try{
      QuerySnapshot snapshot = await transactionColection.get();
      return snapshot.docs.map
        (
              (doc) => TransactionModel.fromMap(doc.data() as Map<String,dynamic>)
        ).toList();
    }
    catch(e){
      print("Loi khi lay danh sach giao dich");
      return [];
    }
 }
 Future<void> updateTransaction(TransactionModel transaction) async {
   try{
     await transactionColection.doc(transaction.id).update(transaction.toMap());
     print('cap nhat giao dich thanh cong');
   }
   catch(e){
      print('Loi roi');
   }
 }
 Future<void> deleteTransaction(String id)async{
    try{
      await transactionColection.doc(id).delete();
      print('xoa giao dich thanh cong');

    }
    catch(e){
      print('xoa giao dich that bai');

    }
 }
}