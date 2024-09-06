
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'dart:math';

class Budget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Budget();
  }
}

class BudgetItem {
  final String budgetTittle;
  final String description;

  BudgetItem({required this.budgetTittle, required this.description});
}

class _Budget extends State<Budget> {
  bool _isExpanded = false;
  double? _devHeight, _devWidth;
  List<BudgetItem> budgets = [
    BudgetItem(
      budgetTittle: 'Tiền tiêu vặt',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    BudgetItem(
      budgetTittle: 'Tiền ăn tháng 9',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    BudgetItem(
      budgetTittle: 'Tiền Skincare',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    BudgetItem(
      budgetTittle: 'Tiền Skincare',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    //
    BudgetItem(
      budgetTittle: 'Tiền Skincare',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    //
    BudgetItem(
      budgetTittle: 'Tiền Skincare',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    //
    BudgetItem(
      budgetTittle: 'Tiền Skincare',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    //
    BudgetItem(
      budgetTittle: 'Tiền Skincare',
      description: 'Cập nhật mới nhất \n 1-9-2024',
    ),
    //
    // Thêm nhiều BudgetItem khác vào đây
  ];

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
            // color: Theme.of(context).scaffoldBackgroundColor,
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
            children: [_budgetList(), calendarView()],
          ),
        )
      // body:
    );
  }

  Widget _budgetList() {
    final displayedBudgets = _isExpanded ? budgets : budgets.take(4).toList();

    return AnimatedContainer(
      padding: EdgeInsets.all(15),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isExpanded ? _devHeight! * 0.75 : _devHeight! * 0.59,
      // Adjust height based on screen size
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: _budgetCard(displayedBudgets),
          ),
          Container(
            width: _devHeight!*0.44,
            alignment: Alignment.center,

            padding: const EdgeInsets.only(left: 15),
            child: Row(

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                addNewBudget(),
                if (budgets.length > 4)
                  takeMoreBudget(), // Conditional rendering
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget takeMoreBudget() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded; // Toggle expanded state
            });
          },
          child: Container(
            height: 50,
            width: _devWidth! * 0.38,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_isExpanded ? 'Thu gọn' : 'Hiển thị thêm',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ));
  }

  Widget _budgetCard(List<BudgetItem> budgets) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        // Bạn có thể thêm nội dung để hiển thị mỗi ô (card) ở đây
        return Card(
          color: getRandomColor(),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  budgets[index].budgetTittle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  budgets[index].description,
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
        onPressed: () {},
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

  Widget historyPending() {
    return Column(
      children: [
        ListView.builder(itemBuilder: (context, index) {
          return ListTile(
            title: Text('Nhan 20 tu ong A'),
          );
        })
      ],
    );
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

