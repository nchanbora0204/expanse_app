import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionAnalysis extends GetxController  {

  Future<void> initHive() async {
    await Hive.initFlutter();
    // Mở box 'notificationBox'
    if (!Hive.isBoxOpen('imageValue')) {
      await Hive.openBox('imageValue');
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await initHive();  // Khởi tạo Hive
    loadImageValueFromHive(); // Tải dữ liệu từ box sau khi box được mở
  }
  List<Map<String, dynamic>> transactions = [];
  void loadImageValueToHive() {
    var box = Hive.box('imageValue');
    box.put('imageValue',transactions);
  }
  void loadImageValueFromHive() {
    if (!Hive.isBoxOpen('imageValue')) {
      print('Box "imageValue" is not open. Cannot load data.');
      return; // Hoặc mở box ở đây nếu cần thiết
    }
    var box = Hive.box('imageValue');
    List<dynamic>? storedImageValues = box.get('imageValue', defaultValue: []);
    if (storedImageValues != null && storedImageValues.isNotEmpty) {
      transactions = List<Map<String, dynamic>>.from(storedImageValues);
    }
  }
  // Hàm nhận diện văn bản từ ảnh
  Future<String> recognizeTextFromImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    String recognizedText = '';

    try {
      RecognizedText recognizedResult =
      await textRecognizer.processImage(inputImage);
      recognizedText = recognizedResult.text;
    } catch (e) {
      print('Lỗi nhận diện văn bản: $e');
    } finally {
      textRecognizer.close();
    }
    print('Recognized text: $recognizedText');
    return recognizedText;
  }

  // Phương thức sinh ID ngẫu nhiên cho mỗi giao dịch
  String generateId() {
    var random = Random();
    return String.fromCharCodes(
        List.generate(10, (index) => random.nextInt(33) + 89)); // ID 10 kí tự
  }

  // Phương thức tách số tiền và chuyển sang double
  double extractAmount(String transaction) {
    String cleaned = transaction.replaceAll(RegExp(r'[^\d.]'), ''); // Xóa hết ký tự không phải số
    return double.tryParse(cleaned) ?? 0.0; // Chuyển đổi thành double
  }

  // Hàm phân tích giao dịch từ văn bản
  List<Map<String, dynamic>> analyzeTransaction(String recognizedText) {


    // Regex tìm thu nhập (số tiền dương với dấu +)
    RegExp incomeRegex = RegExp(r'\+(\d{1,3}(,\d{3})*VND)');
    // Regex tìm chi tiêu (số tiền âm với dấu -)
    RegExp expenseRegex = RegExp(r'-(\d{1,3}(,\d{3})*VND)');

    // Tìm tất cả thu nhập
Iterable<RegExpMatch> incomeMatches = incomeRegex.allMatches(recognizedText);
    for (var match in incomeMatches) {
      String transaction = match.group(0) ?? '';
      transactions.add({
        'id': generateId(),
        'type': 'income',
        'amount': extractAmount(transaction)
      });
    }

    // Tìm tất cả chi tiêu
    Iterable<RegExpMatch> expenseMatches = expenseRegex.allMatches(recognizedText);
    for (var match in expenseMatches) {
      String transaction = match.group(0) ?? '';
      transactions.add({
        'id': generateId(),
        'type': 'expense',
        'amount': extractAmount(transaction)
      });
    }
    print(transactions);
    return transactions;
  }
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Nhận diện văn bản từ ảnh
      String recognizedText = await recognizeTextFromImage(File(pickedFile.path));

      // Phân tích thu nhập và chi tiêu
      List<Map<String, dynamic>> transactions = analyzeTransaction(recognizedText);

      double totalIncome = 0.0;
      double totalExpense = 0.0;

      // Tính tổng thu nhập và chi tiêu từ danh sách giao dịch
      for (var transaction in transactions) {
        if (transaction['type'] == 'income') {
          totalIncome += transaction['amount'];
        } else if (transaction['type'] == 'expense') {
          totalExpense += transaction['amount'];
        }
      }

      DateTime now = DateTime.now();

      await _saveTransactionData(totalIncome, totalExpense, now); // Gọi phương thức lưu
    }
  }

  Future<void> _saveTransactionData(
      double income, double expense, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('savedIncome', income); // Lưu trữ giá trị thu nhập
    await prefs.setDouble('savedExpense', expense); // Lưu trữ giá trị chi tiêu
    await prefs.setString('savedDate', DateFormat('dd/MM/yyyy').format(date)); // Lưu trữ ngày


    final  _income = income.toString(); // Cập nhật trạng thái thu nhập
      final _expense = expense.toString(); // Cập nhật trạng thái chi tiêu
      final _date = DateFormat('dd/MM/yyyy').format(date); // Cập nhật trạng thái ngày


    print("Saved Income: $_income, Expense: $_expense, Date: $_date");
  }


}

extension on List<Map<String, dynamic>> {
  set value(List<Map<String, dynamic>> value) {}
}