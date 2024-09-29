import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:money_lover/firebaseService/other_services.dart';
import 'package:money_lover/models/category_model.dart';

class AddCategoryForm extends StatefulWidget {
  const AddCategoryForm({Key? key}) : super(key: key);

  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  int _type = 0;
  double _amount = 0.0;
  final CategoryService _categoryService = CategoryService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addCategoryFormTitle,
        style: TextStyle(
          color: theme.brightness == Brightness.light
              ? Colors.black
              : Colors.white
        ),),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.brightness == Brightness.light
              ? Colors.black
              : Colors.white, // Màu nút "Back" thay đổi theo chế độ sáng/tối
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNameField(theme, localizations),
                    const SizedBox(height: 24),
                    _buildAmountField(theme, localizations),
                    const SizedBox(height: 24),
                    _buildTypeSelector(theme, localizations),
                    const SizedBox(height: 32),
                    _buildSaveButton(theme, localizations),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: localizations.addCategoryFormCategoryName,
        prefixIcon: Icon(Icons.category, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.addCategoryFormErrorEmptyName;
        }
        return null;
      },
      onSaved: (value) {
        _name = value!;
      },
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildAmountField(ThemeData theme, AppLocalizations localizations) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: localizations.addCategoryFormAmount,
        prefixIcon: Icon(Icons.attach_money, color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localizations.addCategoryFormErrorEmptyAmount;
        } else if (double.tryParse(value) == null) {
          return localizations.addCategoryFormErrorInvalidAmount;
        }
        return null;
      },
      onSaved: (value) {
        _amount = double.tryParse(value!) ?? 0.0;
      },
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildTypeSelector(ThemeData theme, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.addCategoryFormCategoryType,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                theme,
                localizations.addCategoryFormExpense,
                Icons.remove_circle_outline,
                0,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTypeOption(
                theme,
                localizations.addCategoryFormIncome,
                Icons.add_circle_outline,
                1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption(ThemeData theme, String label, IconData icon, int value) {
    final isSelected = _type == value;
    return InkWell(
      onTap: () {
        setState(() {
          _type = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(ThemeData theme, AppLocalizations localizations) {
    return ElevatedButton(
      onPressed: _saveCategory,
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Text(
        localizations.addCategoryFormSaveButton,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final id = _generateRandomId();
      final category = CategoryModel(
        id: id,
        name: _name,
        type: _type,
        amount: _amount,
      );

      try {
        await _categoryService.addCategory(category);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category saved successfully')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving category: $e')),
        );
      }
    }
  }

  String _generateRandomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return 'cat${List.generate(6, (index) => chars[random.nextInt(chars.length)]).join()}';
  }
}
