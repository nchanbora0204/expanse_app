import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_lover/common/color_extension.dart';
import 'package:money_lover/models/category_model.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/firebaseService/other_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
  final String amount; // Trường để nhận số tiền

  // Constructor để nhận amount từ trang TransactionListPage
  AddTransactionForm({required this.amount});
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;

  DateTime _selectedDate = DateTime.now();
  String _description = '';
  String _categoryId = '';
  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    // Chuyển đổi giá trị amount sang kiểu double và gán cho biến _amount
    String numericAmount = widget.amount.replaceAll(RegExp(r'[^0-9]'), '');
    _amount = double.tryParse(numericAmount) ?? 0;
    print('Received amount: $_amount');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.addTransactionTitle),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAmountField(theme, localizations),
              _buildTitleField(theme, localizations),
              _buildDesField(theme, localizations),
              _buildCategoryDropdown(theme, localizations),
              const SizedBox(height: 20),
              _buildDateSelector(theme, localizations),
              const SizedBox(height: 20),
              _buildSaveButton(theme, localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: localizations.transactionTitle,
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
          return localizations.errorTitleRequired;
        }
        return null;
      },
      onSaved: (value) {
        _title = value!;
      },
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }

  Widget _buildAmountField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      initialValue: _amount.toString(),
      // Đặt giá trị khởi tạo
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        labelText: localizations.transactionAmount,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.errorAmountRequired;
        }
        if (double.tryParse(value) == null) {
          return localizations.errorAmountInvalid;
        }
        return null;
      },
      onSaved: (value) {
        _amount = double.parse(value!);
      },
    );
  }

  Widget _buildDesField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: localizations.transactionDescription,
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
      onSaved: (value) {
        _description = value!;
      },
    );
  }

  Widget _buildCategoryDropdown(
      ThemeData theme, AppLocalizations localizations) {
    return FutureBuilder<List<CategoryModel>>(
      future: _categoryService.getCategory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('Đang tải danh mục...',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color));
        }

        if (snapshot.hasError) {
          return Text('Lỗi khi tải danh mục',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color));
        }

        return DropdownButtonFormField<String>(
          items: snapshot.data!.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _categoryId = value!;
            });
          },
          decoration: InputDecoration(
            labelText: localizations.transactionCategory,
            labelStyle: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSelector(ThemeData theme, AppLocalizations localizations) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Ngày giao dịch: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(
                    fontSize: 16, color: theme.textTheme.bodyMedium?.color),
              ),
            ),
            TextButton(
              onPressed: () => _selectDate(),
              child: Text(
                'Chọn ngày giao dịch',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme, AppLocalizations localizations) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();

            // Sinh id ngẫu nhiên cho transaction
            final id = _generateRandomId();

            final transaction = TransactionModel(
              id: id,
              title: _title,
              amount: _amount,
              date: _selectedDate,
              categoryId:
              _categoryId, // Chắc chắn rằng categoryId được truyền đúng
            );

            try {
              await _transactionService.addTransaction(transaction);
              print('Giao dịch đã được lưu');
              Navigator.pop(context);
            } catch (e) {
              print('Lỗi khi lưu giao dịch: $e');
            }
          }
        },
        child: Text(localizations.saveTransaction),
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

  // Phương thức để sinh id ngẫu nhiên với định dạng 'trXXXXXX'
  String _generateRandomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'tr' +
        List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}