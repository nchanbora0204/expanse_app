import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_lover/background_services/transaction_hunter.dart';
import 'package:money_lover/view/main_pages/pendding/add_transaction.dart';
import 'package:money_lover/view/main_pages/pendding/transaction_list.dart';
import 'package:money_lover/view/main_tab/main_tab_view.dart';

class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> with WidgetsBindingObserver {
  final HunterService hunterService = Get.put(HunterService());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Khi ứng dụng quay lại foreground, kiểm tra quyền và tiếp tục lắng nghe
      hunterService.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    hunterService.requestPermission(); // Yêu cầu quyền thông báo khi khởi tạo trang
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) =>
                   TransactionList() // Truyền số tiền
              ),
            ); // Quay về trang trước
          },
        ),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: hunterService.displayList.length,
          itemBuilder: (context, index) {
            final notification = hunterService.displayList[index];
            return ListTile(
              title: Text("${notification['key']} - ${notification['value']}"),
              subtitle: Text(hunterService.getTimeElapsed(notification['timestamp'])),
              onTap: () {
                // Lưu giá trị từ thông báo
                String value = notification['value'];

                // Xóa phần tử khi nhấp vào
                hunterService.displayList.removeAt(index);

                // Điều hướng đến trang AddTransactionForm
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddTransactionForm(amount: value),
                    // Truyền số tiền
                  ),
                );

              },
            );
          },
        );
      }),
    );
  }
}
