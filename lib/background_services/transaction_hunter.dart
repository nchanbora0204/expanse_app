import 'package:get/get.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:intl/intl.dart';

class HunterService extends GetxController {
  RxList<Map<String, dynamic>> notiList = RxList<Map<String, dynamic>>();
  RxList<Map<String, dynamic>> displayList = RxList<Map<String, dynamic>>(); // Danh sách hiển thị

  // Khai báo biến flag để kiểm tra xem đã lắng nghe stream chưa
  bool _isListening = false;

  // Yêu cầu quyền nhận thông báo
  void requestPermission() async {
    final bool status = await NotificationListenerService.isPermissionGranted();
    if (!status) {
      print("Chưa được cấp quyền. Yêu cầu quyền truy cập...");
      final bool permissionGranted = await NotificationListenerService.requestPermission();
      if (permissionGranted) {
        print("Quyền truy cập thông báo đã được cấp");
        // Bắt đầu lắng nghe sau khi được cấp quyền

        _startListening();
      } else {
        print("Người dùng từ chối quyền truy cập thông báo");
      }
    } else {
      // Nếu đã có quyền, bắt đầu lắng nghe
      _startListening();
    }
  }

  // Hàm khởi tạo lắng nghe thông báo (đảm bảo chỉ chạy một lần)
  void _startListening()async {
    if (!_isListening) {
      print("Đang lắng nghe thông báo: Bật");
      _isListening = true; // Đặt flag đã lắng nghe
      NotificationListenerService.notificationsStream.listen((event) {
        final key = extractKey(event.content ?? "");
        final value = extractAmount(event.content ?? "");
        final timestamp = DateTime.now(); // Thời gian hiện tại khi nhận thông báo

        if (key.isNotEmpty && value.isNotEmpty)  {
          // Lưu vào notiList
           notiList.add({"key": key, "value": value, "timestamp": timestamp});

          // Chỉ thêm vào displayList nếu chưa có trong đó
          _addToDisplayList({"key": key, "value": value, "timestamp": timestamp});


          print(displayList); // Kiểm tra xem dữ liệu được thêm đúng không
        }
        cleanOldNoti();
      });
    } else {
      print("Đã lắng nghe thông báo trước đó");
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
      displayList.add(notification); // Thêm nếu không trùng trong thời gian giới hạn
    }
  }

  // Hàm để tách key
  String extractKey(String content) {
    RegExp regExpKey = RegExp(r"nhận|chuyển", caseSensitive: false);
    if (regExpKey.hasMatch(content)) {
      return regExpKey.firstMatch(content)?.group(0) ?? "";
    }
    return "";
  }

  // Hàm để tách số tiền từ thông báo
  String extractAmount(String content) {
    RegExp regExpValues = RegExp(r"(\d{1,3}(?:\.\d{3})* vnđ|\d+ vnđ)");
    if (regExpValues.hasMatch(content)) {
      return regExpValues.firstMatch(content)?.group(0) ?? "";
    }
    return "";
  }

  // Tính thời gian từ thông báo đến hiện tại (ví dụ: "2 giờ trước")
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

  void cleanOldNoti() {
    final now = DateTime.now();
    notiList.removeWhere((notification) {
      final timestamp = notification['timestamp'];
      final difference = now.difference(timestamp).inDays;
      return difference > 15;
    });
  }

}

