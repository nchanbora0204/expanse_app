import 'package:flutter/material.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';// Thay đổi theo đường dẫn thực tế

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();
  final TransactionService _transactionService = TransactionService();
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

  Widget _buildAmountField(ThemeData theme) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Số tiền',
        labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
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
            'Ngày: ${_selectedDate.toLocal()}'.split(' ')[0],
            style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color),
          ),
        ),
        TextButton(
          onPressed: _selectDate,
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

            final transaction = TransactionModel(
              id: DateTime.now().toString(),
              title: _title,
              amount: _amount,
              date: _selectedDate,
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
