import 'dart:math';
import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/other_services.dart';
// Thay đổi service để phù hợp với category
import 'package:money_lover/models/category_model.dart';

class AddCategoryForm extends StatefulWidget {
  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _type = 0; // 0: khoản chi, 1: khoản thu
  double _amount = 0.0; // Số tiền có thể chi
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Danh Mục Mới'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNameField(theme),
                const SizedBox(height: 20),
                _buildAmountField(theme),
                const SizedBox(height: 20),
                _buildTypeSelector(theme), // Thêm lựa chọn cho khoản chi hay thu
                const SizedBox(height: 20),
                _buildSaveButton(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Tên Danh Mục',
        labelStyle: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập tên danh mục';
        }
        return null;
      },
      onSaved: (value) {
        _name = value!;
      },
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }

  Widget _buildAmountField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Số Tiền',
        labelStyle: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số tiền';
        }
        return null;
      },
      onSaved: (value) {
        _amount = double.tryParse(value!) ?? 0.0; // Chuyển đổi giá trị sang double
      },
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Loại Danh Mục:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _type = 0; // Khoản chi
                });
              },
              child: Row(
                children: [
                  Radio<int>(
                    value: 0,
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  const Text('Khoản Chi'),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _type = 1; // Khoản thu
                });
              },
              child: Row(
                children: [
                  Radio<int>(
                    value: 1,
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  const Text('Khoản Thu'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            // Sinh id ngẫu nhiên cho danh mục
            final _id = _generateRandomId();
            final category = CategoryModel(
              id: _id,
              name: _name,
              type: _type,
              amount: _amount, // Số tiền có thể chi
            );

            try {
              await _categoryService.addCategory(category);
              print('Danh mục đã được lưu');
              Navigator.pop(context, true);
            } catch (e) {
              print('Lỗi khi lưu danh mục: $e');
            }
          }
        },
        child: const Text('Lưu Danh Mục'),
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Phương thức để sinh id ngẫu nhiên với định dạng 'catXXXXXX'
  String _generateRandomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'cat' + List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
