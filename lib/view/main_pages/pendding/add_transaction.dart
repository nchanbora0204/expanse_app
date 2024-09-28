import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_lover/models/category_model.dart';
import 'package:money_lover/models/transaction_model.dart';
import 'package:money_lover/firebaseService/transactionServices.dart';
import 'package:money_lover/firebaseService/other_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTransactionForm extends StatefulWidget {
  final String amount;

  AddTransactionForm({required this.amount});

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  final TransactionService _transactionService = TransactionService();
  final CategoryService _categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.amount);
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addTransactionTitle),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAmountField(theme, localizations),
                SizedBox(height: 20),
                _buildTitleField(theme, localizations),
                SizedBox(height: 20),
                _buildDescriptionField(theme, localizations),
                SizedBox(height: 20),
                _buildCategoryDropdown(theme, localizations),
                SizedBox(height: 20),
                _buildDateSelector(theme, localizations),
                SizedBox(height: 30),
                _buildSaveButton(theme, localizations),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: localizations.transactionAmount,
        prefixIcon: Icon(Icons.attach_money, color: theme.primaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.errorAmountRequired;
        }
        if (double.tryParse(value) == null) {
          return localizations.errorAmountInvalid;
        }
        return null;
      },
    );
  }

  Widget _buildTitleField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: localizations.transactionTitle,
        prefixIcon: Icon(Icons.title, color: theme.primaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.errorTitleRequired;
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: localizations.transactionDescription,
        prefixIcon: Icon(Icons.description, color: theme.primaryColor),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
        ),
      ),
      maxLines: 3,
    );
  }

  Widget _buildCategoryDropdown(ThemeData theme, AppLocalizations localizations) {
    return FutureBuilder<List<CategoryModel>>(
      future: _categoryService.getCategory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error loading categories');
        }
        return DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          items: snapshot.data!.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
          },
          decoration: InputDecoration(
            labelText: localizations.transactionCategory,
            prefixIcon: Icon(Icons.category, color: theme.primaryColor),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.primaryColor, width: 2.0),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateSelector(ThemeData theme, AppLocalizations localizations) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: localizations.transactionDate,
          prefixIcon: Icon(Icons.calendar_today, color: theme.primaryColor),
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('yyyy-MM-dd').format(_selectedDate),
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme, AppLocalizations localizations) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _saveTransaction,
        child: Text(
          localizations.saveTransaction,
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
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

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        categoryId: _selectedCategoryId ?? '',
        description: _descriptionController.text,
      );

      try {
        await _transactionService.addTransaction(transaction);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving transaction: $e')),
        );
      }
    }
  }
}