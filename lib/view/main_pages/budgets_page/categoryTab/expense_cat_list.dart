import 'dart:math';
import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/other_services.dart'; // Sửa đường dẫn thành service cho Category
import 'package:money_lover/models/category_model.dart'; // Sửa đường dẫn thành model cho Category
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/view/main_pages/budgets_page/add_category.dart';
import 'package:money_lover/firebaseService/other_services.dart';

class ExpenseCatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<ExpenseCatList> {
  bool _isExpanded = false;
  double? _devHeight, _devWidth;
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _categoryList(),
            calendarView(),
          ],
        ),
      ),
    );
  }

  Widget _categoryList() {
    return StreamBuilder<List<CategoryModel>>(
      stream: _categoryService.getCategoryStream(), // Sử dụng stream
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Lỗi khi tải dữ liệu');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Chưa có dữ liệu danh mục');
        } else {
          final category = snapshot.data!;
          final displayedCategories = category.toList();

          return AnimatedContainer(
            padding: EdgeInsets.all(15),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _devHeight! * 0.67,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _categoryCard(displayedCategories),
                ),
                Container(
                  width: _devWidth! * 0.44,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      addNewCategory(),
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

  Widget _categoryCard(List<CategoryModel> categories) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: categories.length,
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
                  categories[index].name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget addNewCategory() {
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryForm()));
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
