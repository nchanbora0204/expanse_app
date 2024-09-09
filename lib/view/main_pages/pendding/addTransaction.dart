import 'package:flutter/material.dart';

class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  double _amount = 0;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm Giao Dịch Mới'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: theme.appBarTheme.foregroundColor), // Màu icon
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tên giao dịch',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color), // Màu chữ label
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor), // Màu viền
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary), // Màu viền khi focus
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên giao dịch';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color), // Màu chữ label
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.dividerColor), // Màu viền
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary), // Màu viền khi focus
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
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ngày: ${_selectedDate.toLocal()}'.split(' ')[0],
                      style: TextStyle(fontSize: 16, color: theme.textTheme.bodyMedium?.color), // Màu chữ
                    ),
                  ),
                  TextButton(
                    onPressed: _selectDate,
                    child: Text(
                      'Chọn ngày',
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color), // Màu chữ
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Thêm logic để lưu giao dịch mới vào danh sách giao dịch
                      print('Giao dịch: $_title, Số tiền: $_amount, Ngày: $_selectedDate');
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Lưu Giao Dịch'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary, backgroundColor: theme.colorScheme.primary, padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ), // Màu chữ
                  ),
                ),
              )
            ],
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
