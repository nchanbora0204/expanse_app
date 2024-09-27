import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool emailNotifications = true;
  bool appNotifications = false;
  bool smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt Thông Báo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn loại thông báo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildNotificationToggle('Thông báo qua Email', emailNotifications,
                (value) {
              setState(() {
                emailNotifications = value;
              });
            }),
            _buildNotificationToggle('Thông báo qua Ứng dụng', appNotifications,
                (value) {
              setState(() {
                appNotifications = value;
              });
            }),
            _buildNotificationToggle('Thông báo qua SMS', smsNotifications,
                (value) {
              setState(() {
                smsNotifications = value;
              });
            }),
            const Divider(height: 40),
            Text(
              'Lịch Trình Nhắc Nhở',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // TODO: Add scheduling options here
            const SizedBox(height: 20),
            Text(
              'Gợi ý Thông Báo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildSuggestion('Thông báo về sự kiện khuyến mãi'),
            _buildSuggestion('Thông báo cập nhật tài khoản'),
            _buildSuggestion('Thông báo từ bạn bè'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
      String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSuggestion(String suggestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        suggestion,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }
}
