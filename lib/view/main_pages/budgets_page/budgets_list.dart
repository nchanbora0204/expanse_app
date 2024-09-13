import 'dart:math';
import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/budget_services.dart'; // Đảm bảo đường dẫn chính xác
import 'package:money_lover/models/budget_model.dart'; // Đảm bảo đường dẫn chính xác
import 'package:money_lover/common/color_extension.dart';
class Budget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Budget();
  }
}

class _Budget extends State<Budget> {
  bool _isExpanded = false;
  double? _devHeight, _devWidth;
  late Future<List<BudgetModel>> _budgetFuture;
  final BudgetService _budgetService = BudgetService();

  @override
  void initState() {
    super.initState();
    _budgetFuture = _budgetService.getBudgets(); // Lấy dữ liệu khi khởi tạo
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Image.asset(
          "assets/img/app_logo.png",
          width: _devWidth! * 0.4,
          fit: BoxFit.contain,
        ),
        iconTheme: IconThemeData(
          color: theme.appBarTheme.foregroundColor,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _budgetList(),
            calendarView(),
          ],
        ),
      ),
    );
  }

  Widget _budgetList() {
    return FutureBuilder<List<BudgetModel>>(
      future: _budgetFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Lỗi khi tải dữ liệu');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Chưa có dữ liệu ngân sách');
        } else {
          final budgets = snapshot.data!;
          final displayedBudgets = _isExpanded ? budgets : budgets.take(4).toList();

          return AnimatedContainer(
            padding: EdgeInsets.all(15),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isExpanded ? _devHeight! * 0.75 : _devHeight! * 0.59,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _budgetCard(displayedBudgets),
                ),
                Container(
                  width: _devWidth! * 0.44,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      addNewBudget(),
                      if (budgets.length > 4) takeMoreBudget(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget takeMoreBudget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Container(
          height: 50,
          width: _devWidth! * 0.38,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _isExpanded ? 'Thu gọn' : 'Hiển thị thêm',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _budgetCard(List<BudgetModel> budgets) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        return Card(
          color: getRandomColor(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  budgets[index].tittle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  budgets[index].amount.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget addNewBudget() {
    return Container(
      height: 50,
      width: _devWidth! * 0.4,
      decoration: BoxDecoration(
        color: TColor.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          // Chức năng để thêm ngân sách mới
        },
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    List<Color> colors = [
      TColor.gray40,
      TColor.gray50,
    ];
    return colors[random.nextInt(colors.length)];
  }

  Widget calendarView() {
    return Container(
      height: _devHeight! * 0.05,
      child: Text(
        "Tháng 9 ",
        style: TextStyle(
            fontWeight: FontWeight.w900, fontSize: 30, color: TColor.gray20),
      ),
    );
  }
}
