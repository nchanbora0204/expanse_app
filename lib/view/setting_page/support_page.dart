import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.support),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Cho phép cuộn khi có nhiều nội dung
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.support,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Cỡ chữ tiêu đề lớn hơn
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.supportDescription, // Giới thiệu về hỗ trợ
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600], // Màu sắc nhạt hơn cho phần mô tả
                ),
              ),
              const SizedBox(height: 20),

              // Nút gửi email hỗ trợ
              _buildSupportButton(
                context,
                title: AppLocalizations.of(context)!.sendEmailSupport,
                onPressed: () {
                  // Thực hiện chức năng gửi email hỗ trợ
                },
              ),

              const SizedBox(height: 20),

              // FAQs Section
              Text(
                AppLocalizations.of(context)!.faqs,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              _buildFAQTile(context, 'Câu hỏi 1', 'Mô tả câu hỏi 1...'),
              _buildFAQTile(context, 'Câu hỏi 2', 'Mô tả câu hỏi 2...'),

              // Nút liên hệ hỗ trợ
              const SizedBox(height: 20),
              _buildSupportButton(
                context,
                title: AppLocalizations.of(context)!.contactSupport,
                onPressed: () {
                  // Thực hiện chức năng liên hệ hỗ trợ
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportButton(BuildContext context, {required String title, required VoidCallback onPressed}) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15), // Tăng kích thước nút
        backgroundColor: theme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bo góc nút
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 16, // Cỡ chữ lớn hơn
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFAQTile(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10), // Khoảng cách giữa các câu hỏi
      elevation: 2,
      child: ListTile(
        title: Text(
          question,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(answer),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Chức năng mở rộng câu hỏi
        },
      ),
    );
  }
}
