import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool emailNotifications = true;
  bool appNotifications = false;
  bool smsNotifications = false;
  TimeOfDay reminderTime = TimeOfDay(hour: 20, minute: 0);
  List<String> selectedDays = ['Mon', 'Wed', 'Fri'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt Thông Báo'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Chọn loại thông báo'),
            _buildNotificationToggles(),
            _buildDivider(),
            _buildHeader('Lịch Trình Nhắc Nhở'),
            _buildReminderSchedule(),
            _buildDivider(),
            _buildHeader('Gợi ý Thông Báo'),
            _buildSuggestions(),
            _buildDivider(),
            _buildHeader('Cài đặt Nâng cao'),
            _buildAdvancedSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildNotificationToggles() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildNotificationToggle(
            'Thông báo qua Email',
            Ionicons.mail_outline,
            emailNotifications,
                (value) => setState(() => emailNotifications = value),
          ),
          _buildNotificationToggle(
            'Thông báo qua Ứng dụng',
            Ionicons.notifications_outline,
            appNotifications,
                (value) => setState(() => appNotifications = value),
          ),
          _buildNotificationToggle(
            'Thông báo qua SMS',
            Ionicons.chatbubble_outline,
            smsNotifications,
                (value) => setState(() => smsNotifications = value),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(String title, IconData icon, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: _getIconColor()),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Color _getIconColor() {
    // Đổi màu biểu tượng tùy thuộc vào chế độ sáng/tối
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  Widget _buildReminderSchedule() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Ionicons.time_outline, color: _getIconColor()),
            title: Text('Thời gian nhắc nhở'),
            trailing: Text(reminderTime.format(context)),
            onTap: _selectReminderTime,
          ),
          ListTile(
            leading: Icon(Ionicons.calendar_outline, color: _getIconColor()),
            title: Text('Ngày nhắc nhở'),
            subtitle: Text(selectedDays.join(', ')),
            onTap: _selectReminderDays,
          ),
        ],
      ),
    );
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );
    if (picked != null && picked != reminderTime) {
      setState(() {
        reminderTime = picked;
      });
    }
  }

  void _selectReminderDays() {
    // TODO: Implement day selection dialog
  }

  Widget _buildSuggestions() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildSuggestion('Thông báo về sự kiện khuyến mãi', Ionicons.gift_outline),
          _buildSuggestion('Thông báo cập nhật tài khoản', Ionicons.person_outline),
          _buildSuggestion('Thông báo từ bạn bè', Ionicons.people_outline),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String suggestion, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: _getIconColor()),
      title: Text(suggestion),
      trailing: Icon(Ionicons.chevron_forward),
      onTap: () {
        // TODO: Implement suggestion action
      },
    );
  }

  Widget _buildAdvancedSettings() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Ionicons.options_outline, color: _getIconColor()),
            title: Text('Tùy chỉnh âm thanh thông báo'),
            trailing: Icon(Ionicons.chevron_forward),
            onTap: () {
              // TODO: Implement sound customization
            },
          ),
          ListTile(
            leading: Icon(Ionicons.color_palette_outline, color: _getIconColor()),
            title: Text('Tùy chỉnh màu sắc thông báo'),
            trailing: Icon(Ionicons.chevron_forward),
            onTap: () {
              // TODO: Implement color customization
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 32, thickness: 1, indent: 16, endIndent: 16);
  }
}