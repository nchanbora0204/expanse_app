import 'dart:math';
import 'package:flutter/material.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  String _description = '';
  String _budgetId = '';
  final TransactionService _transactionService = TransactionService();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Giao Dịch Mới'),
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
              _buildDesField(theme),
              _buildBudgetIdField(theme),
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
          fontFamily: 'Roboto', // Đảm bảo font chữ hỗ trợ tiếng Việt
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
        fontFamily: 'Roboto', // Áp dụng font chữ cho TextFormField
        fontSize: 18,
      ),
    );
  }

  Widget _buildAmountField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Số tiền',
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildDesField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Ghi chú chi tiết',
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildBudgetIdField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Budget ID',
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập budget ID';
        }
        return null;
      },
      onSaved: (value) {
        _budgetId = value!;
      },
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return Column(
      children: [

        Row(
          children: [
            Expanded(
              child: Text(
                'Ngày kết thúc: ${_endDate.toLocal()}',
                style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
              ),
            ),
            TextButton(
              onPressed: () => _selectDate(isStartDate: false),
              child: Text(
                'Chọn ngày kết thúc',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
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

            // Sinh id ngẫu nhiên cho transaction
            final id = _generateRandomId();

            final transaction = TransactionModel(
              id: id,
              title: _title,
              amount: _amount,
              date: _selectedDate,
              description: _description,
              budgetId: _budgetId,
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
        child: Text('Lưu Giao Dịch'),
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

  // Phương thức để sinh id ngẫu nhiên với định dạng 'trXXXXXX'
  String _generateRandomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'tr' + List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (_selectedDate != null && _selectedDate != DateTime.now()) {
      // Chỉ giữ lại ngày, tháng và năm
      DateTime dateOnly = DateTime(
          _selectedDate.year, _selectedDate.month, _selectedDate.day);

      if (picked != null) {
        setState(() {
          if (isStartDate) {
            _startDate = picked;
          } else {
            _endDate = picked;
          }
        });
      }
    }
  }
}
