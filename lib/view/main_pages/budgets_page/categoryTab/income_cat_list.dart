import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/firebaseService/other_services.dart'; // Sửa đường dẫn thành service cho Category
import 'package:money_lover/models/category_model.dart'; // Sửa đường dẫn thành model cho Category
import 'package:money_lover/models/transaction_model.dart';
import 'package:money_lover/view/main_pages/budgets_page/add_category.dart';
import 'package:money_lover/view/main_pages/budgets_page/transactionByCatId.dart';

class IncomeCatList extends StatefulWidget {
  const IncomeCatList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<IncomeCatList> {
  final bool _isExpanded = false;
  double? _devHeight, _devWidth;
  late Future<List<CategoryModel>> _categoryFuture;
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    _categoryFuture = _categoryService.getCategory(); // Lấy danh sách category
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
            _addNewCategory(),
            calendarView(),
          ],
        ),
      ),
    );
  }

 
  Widget _categoryList() {
    return StreamBuilder<List<CategoryModel>>(
      stream: _categoryService.getCategoryStream(), // Lấy danh sách category
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Lỗi khi tải dữ liệu');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('Chưa có dữ liệu danh mục');
        } else {
          // Lọc danh mục chỉ có type là 0 (khoản chi)
          final categories = snapshot.data!.where((category) => category.type == 1).toList();

          if (categories.isEmpty) {
            return const Text('Chưa có khoản chi nào.');
          }

          return AnimatedContainer(
            padding: const EdgeInsets.all(15),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _devHeight! * 0.67,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _categoryCard(categories),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            
            String categoryId = categories[index].id;
            List<TransactionModel> transactions = await _categoryService.getTransactionsByCategory(categoryId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionsPage(transactions: transactions),
              ),
            );
          },
          child: Card(
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
                  const SizedBox(height: 5),
                  // Hiển thị số tiền cho mỗi khoản chi
                  Text(
                    '${categories[index].amount} VNĐ', // Giả sử 'amount' là field trong CategoryModel
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _addNewCategory() {
    return Container(
      height: 50,
      width: _devWidth! * 0.4,
      decoration: BoxDecoration(
        color: TColor.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder:(context)=>AddCategoryForm() )); // Chức năng để thêm danh mục mới
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
    return SizedBox(
      height: _devHeight! * 0.05,
      child: Text(
        "Tháng 9 ",
        style: TextStyle(
            fontWeight: FontWeight.w900, fontSize: 30, color: TColor.gray20),
      ),
    );
  }
}
