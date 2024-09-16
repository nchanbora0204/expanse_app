import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_lover/models/category_model.dart';
import 'package:money_lover/models/transaction_model.dart';
class CategoryService{
  final CollectionReference categoryCollection = FirebaseFirestore.instance.collection('category');
  Future<List<TransactionModel>> getTransactionByCategory(String categoryId) async{
    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transaction')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc){
        return TransactionModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    }catch(e){
      print("Services Class: Khong the lay danh sach theo categoryId");
      return [];
    };
  }
  Future<List<CategoryModel>> getCategory() async {
    try {
      QuerySnapshot snapshot = await categoryCollection.get();
      return snapshot.docs.map(
              (doc) => CategoryModel.fromMap(doc.data() as Map<String, dynamic>)
      ).toList();
    } catch (e, stacktrace) {
      print("Category Service Class : Lỗi khi lấy danh sách giao dịch: $e");
      print("Stacktrace: $stacktrace");
      return [];
    }
  }
  Future<void> addCategory(CategoryModel category) async{
    try{
      await categoryCollection.doc(category.id).set(category.toMap());
      print('Category Service Class: Them moi thanh cong');
    }catch(e){
      print('Category Service Class: Loi khi them moi Category');
    }
  }
  Future<void> updateCategory(CategoryModel category) async {
    try{
      await categoryCollection.doc(category.id).update(category.toMap());
      print('cap nhat giao dich thanh cong');
    }
    catch(e){
      print('Transaction Service Class: Loi roi');
    }
  }
}
