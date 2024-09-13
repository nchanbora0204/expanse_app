import 'dart:math';
import 'package:flutter/material.dart';
import 'package:money_lover/firebaseService/budget_Services.dart';
import 'package:money_lover/models/budget_model.dart';

class AddBudgetForm extends StatefulWidget {
  @override
  _AddBudgetFormState createState() => _AddBudgetFormState();
}

class _AddBudgetFormState extends State<AddBudgetForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  final BudgetService _budgetService = BudgetService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Ngân Sách Mới'),
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
              _buildTitleField(theme),
              _buildAmountField(theme),
              SizedBox(height: 20),
              _buildDateSelector(theme),
              SizedBox(height: 20),
              _buildSaveButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Tiêu đề',
        labelStyle: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
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
          return 'Vui lòng nhập tiêu đề';
        }
        return null;
      },
      onSaved: (value) {
        _title = value!;
      },
      style: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 18,
      ),
    );
  }

  Widget _buildAmountField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Số tiền',
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
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số tiền';
        }
        if (double.tryParse(value) == null) {
          return 'Vui lòng nhập một số hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _amount = double.parse(value!);
      },
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Ngày kết thúc: ${_selectedDate.toLocal().toString().split(' ')[0]}',
            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
          ),
        ),
        TextButton(
          onPressed: () => _selectDate(),
          child: Text(
            'Chọn ngày',
            style: TextStyle(color: theme.textTheme.bodyMedium?.color),
          ),
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

            // Sinh id ngẫu nhiên cho budget
            final id = _generateRandomId();

            final budget = BudgetModel(
              id: id,
              tittle: _title,
              amount: _amount,
              date: _selectedDate,
            );

            try {
              await _budgetService.addBudget(budget);
              print('Ngân sách đã được lưu');
              Navigator.pop(context);
            } catch (e) {
              print('Lỗi khi lưu ngân sách: $e');
            }
          }
        },
        child: Text('Lưu Ngân Sách'),
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.primary,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // Phương thức để sinh id ngẫu nhiên với định dạng 'bgXXXXXX'
  String _generateRandomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'bg' + List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
