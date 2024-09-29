import 'dart:math';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

class HunterService extends GetxController {
  RxList<Map<String, dynamic>> notiList = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> displayList = RxList<Map<String, dynamic>>(); // Danh sách hiển thị
  bool _isListening = false;

  @override
  Future<void> initHive() async {
    await Hive.initFlutter();
    // Mở box 'notificationBox' 
    if (!Hive.isBoxOpen('notificationBox')) {
      await Hive.openBox('notificationBox');
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await initHive();  // Khởi tạo Hive
    loadNotificationsFromHive(); // Tải thông báo đã lưu khi khởi động ứng dụng
    requestPermission();  // Yêu cầu quyền thông báo
  }

  // Yêu cầu quyền nhận thông báo
  Future<bool> requestPermission() async {
    final bool status = await NotificationListenerService.isPermissionGranted();
    if (!status) {
      print("Chưa được cấp quyền. Yêu cầu quyền truy cập...");
      final bool permissionGranted = await NotificationListenerService.requestPermission();
      if (permissionGranted) {
        print("Quyền truy cập thông báo đã được cấp");
        _startListening();
        return true; // Trả về true nếu quyền được cấp thành công
      } else {
        print("Người dùng từ chối quyền truy cập thông báo");
        return false; // Trả về false nếu người dùng từ chối
      }
    } else {
      _startListening();
      return true; // Trả về true nếu quyền đã có sẵn
    }
  }

  // Hàm khởi tạo lắng nghe thông báo
  void _startListening() async {
    if (!_isListening) {
      print("Đang lắng nghe thông báo: Bật");
      _isListening = true;
      NotificationListenerService.notificationsStream.listen((event) {
        final key = extractKey(event.content ?? "");
        final value = extractAmount(event.content ?? "");
        final timestamp = DateTime.now();

        if (key.isNotEmpty && value.isNotEmpty) {
          // Lưu thông báo vào notiList
          notiList.add({"key": key, "value": value, "timestamp": timestamp});

          // Thêm vào displayList nếu không trùng
          _addToDisplayList({"key": key, "value": value, "timestamp": timestamp});

          // Lưu vào Hive sau khi cập nhật
          saveNotificationsToHive();

          print(displayList); // Kiểm tra dữ liệu
        }
        cleanOldNoti();
      });
    } else {
      print("Đã lắng nghe thông báo trước đó");
    }
  }

  // Lưu thông báo vào Hive
  void saveNotificationsToHive() {
    var box = Hive.box('notificationBox');
    box.put('displayList', displayList);
  }

  String generationNotificationId() {
    final random = Random();
    String idNotifi;
    do {
      idNotifi = 'Noti Id${random.nextInt(10000000).toString().padLeft(6, '0')}';
    } while (notiList.any((notification) => notification['id'] == idNotifi));
    return idNotifi;
  }

  // Tải thông báo từ Hive khi ứng dụng mở lại
  void loadNotificationsFromHive() {
    var box = Hive.box('notificationBox'); // Sử dụng tên box đúng
    List<dynamic>? storedNotifications = box.get('displayList', defaultValue: []);

    if (storedNotifications != null && storedNotifications.isNotEmpty) {
      // Chuyển đổi kiểu dữ liệu về List<Map<String, dynamic>>
      displayList.value = List<Map<String, dynamic>>.from(storedNotifications);
    } else {
      displayList.clear();
    }
  }

  void _addToDisplayList(Map<String, dynamic> notification) {
    bool exists = displayList.any((element) {
      final timeDifference = notification['timestamp'].difference(element['timestamp']).inSeconds;
      return element['key'] == notification['key'] &&
          element['value'] == notification['value'] &&
          timeDifference < 5; // Giới hạn 5 giây
    });

    if (!exists) {
      displayList.add(notification);
    }
  }

  // Tách key từ nội dung thông báo
  String extractKey(String content) {
    RegExp regExpKey = RegExp(r"nhận|chuyển", caseSensitive: false);
    if (regExpKey.hasMatch(content)) {
      return regExpKey.firstMatch(content)?.group(0) ?? "";
    }
    return "";
  }

  // Tách số tiền từ nội dung thông báo
  String extractAmount(String content) {
    RegExp regExpValues = RegExp(r"(\d{1,3}(?:\.\d{3})* vnđ|\d+ vnđ)");
    if (regExpValues.hasMatch(content)) {
      return regExpValues.firstMatch(content)?.group(0) ?? "";
    }
    return "";
  }

  // Tính thời gian trôi qua
  String getTimeElapsed(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return "${difference.inDays} ngày trước";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} giờ trước";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} phút trước";
    } else {
      return "Vừa xong";
    }
  }

  // Xóa thông báo cũ hơn 15 ngày
  void cleanOldNoti() {
    final now = DateTime.now();
    notiList.removeWhere((notification) {
      final timestamp = notification['timestamp'];
      final difference = now.difference(timestamp).inDays;
      return difference > 15;
    });
  }
}
