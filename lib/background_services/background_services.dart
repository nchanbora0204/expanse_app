import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

Future<void> initializeService() async {
  final bgService = FlutterBackgroundService();

  await bgService.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,  // Custom void Method
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Trasaction Hunter',
      initialNotificationContent: 'Đang thu thập thông báo chi tiêu',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,  // Hàm onStart sẽ được gọi khi chạy foreground trên iOS
      autoStart: true,
      // Cho phép chạy ở chế độ background (nền) nếu cần
      onBackground: onIosBackground,
    ), //Cau hinh cho IOS
  );

  // Khởi chạy service
  bgService.startService();
}
void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // Lắng nghe và thu thập thông báo từ ví điện tử
    service.invoke('collectNotification');

    // Một ví dụ về việc thu thập thông báo
    service.on('collectNotification').listen((event) {
      String notificationContent = event!['message'];  // Nội dung thông báo

      // Lưu thông báo vào danh sách (hoặc database)
      // Implement logic để lưu trữ thông báo cho sau này hiển thị
      print(notificationContent);  // In ra console
    });
  }
}

bool onIosBackground(ServiceInstance service) {
  print('iOS Background fetch activated');
  return true;  // Trả về true để cho phép tiếp tục chạy nền
}