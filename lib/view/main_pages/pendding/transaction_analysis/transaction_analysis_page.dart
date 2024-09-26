import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

class TransactionAnalysis {
  //Hàm nhận diện văn bản từ ảnh
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

  //Hàm phân tích giao dịch từ văn bản
  // Hàm phân tích giao dịch từ văn bản
  Map<String, String> analyzeTransaction(String recognizedText) {
    String incom = '';
    String expense = '';

    // Regex tìm thu nhập (số tiền dương với dấu +)
    RegExp incomRegex = RegExp(r'\+(\d{1,3}(,\d{3})*VND)');

    // Regex tìm chi tiêu (số tiền âm với dấu -)
    RegExp expenseRegex = RegExp(r'-(\d{1,3}(,\d{3})*VND)');

    // Tìm tất cả thu nhập
    Iterable<RegExpMatch> incomMatches = incomRegex.allMatches(recognizedText);
    for (var match in incomMatches) {
      incom += (match.group(0) ?? '') + '; '; // Nối tất cả số thu nhập tìm thấy
    }

    // Tìm tất cả chi tiêu
    Iterable<RegExpMatch> expenseMatches = expenseRegex.allMatches(recognizedText);
    for (var match in expenseMatches) {
      expense += (match.group(0) ?? '') + '; '; // Nối tất cả số chi tiêu tìm thấy
    }

    return {
      'income': incom.trim(),
      'expense': expense.trim(),
    };
  }

}
