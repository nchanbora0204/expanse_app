import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import để hỗ trợ đa ngôn ngữ
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/firebaseService/other_services.dart';
import 'package:money_lover/models/category_model.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:money_lover/view/main_pages/budgets_page/add_category.dart';
import 'package:money_lover/view/main_pages/budgets_page/transactionByCatId.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpenseCatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<ExpenseCatList> {
  final CategoryService _categoryService = CategoryService();
  double? _devHeight, _devWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _devHeight = MediaQuery.of(context).size.height;
    _devWidth = MediaQuery.of(context).size.width;

    // Khởi tạo localizations
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _categoryList(),
            _addNewCategoryButton(localizations), // Truyền localizations vào
          ],
        ),
      ),
    );
  }

  Widget _categoryList() {
    return StreamBuilder<List<CategoryModel>>(
      stream: _categoryService.getCategoryStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(AppLocalizations.of(context)!.errorLoadingData); // Sử dụng chuỗi từ localizations
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text(AppLocalizations.of(context)!.noCategoryData); // Sử dụng chuỗi từ localizations
        } else {
          final categories = snapshot.data!.where((category) => category.type == 0).toList();

          if (categories.isEmpty) {
            return Text(AppLocalizations.of(context)!.noExpense); // Sử dụng chuỗi từ localizations
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
                  Text(
                    '${categories[index].amount} VNĐ',
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

  Widget _addNewCategoryButton(AppLocalizations localizations) { // Nhận localizations
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


}