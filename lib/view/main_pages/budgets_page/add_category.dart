import 'dart:math';
import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/other_services.dart';
import 'package:money_lover/models/category_model.dart'; // Thay đổi model để phù hợp với category
import 'package:money_lover/firebaseService/other_services.dart'; // Thay đổi service để phù hợp với category

class AddCategoryForm extends StatefulWidget {
  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _type =  3;
  final CategoryService _categoryService = CategoryService();
  late Future<List<CategoryModel>> _categoriesFuture;

  @override
  Widget  build(BuildContext context) {
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

  Widget _buildSaveButton(ThemeData theme) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            // Sinh id ngẫu nhiên cho danh mục
            final _id = _generateRandomId();
            _type = 0;
            final category = CategoryModel(
              id: _id,
              name: _name,
              type: _type,
            );

            try  {
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
