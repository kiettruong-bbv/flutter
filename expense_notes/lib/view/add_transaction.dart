import 'package:expense_notes/style/custom_colors.dart';
import 'package:expense_notes/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/transaction.dart';
import 'package:expense_notes/widget/date_time_input.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  DateTime _selectedDate = DateTime.now();
  bool _isAddEnable = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const space15 = SizedBox(height: 15);
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      color: theme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Add Transaction',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: CustomColors.white,
                ),
              ),
            ],
          ),
          space15,
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.secondary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.secondary,
                  width: 1,
                ),
              ),
              labelText: 'Name',
              labelStyle: theme.textTheme.caption,
            ),
            onChanged: (_) => _validateButton(),
          ),
          space15,
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.secondary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.secondary,
                  width: 1,
                ),
              ),
              labelText: 'Amount',
              labelStyle: theme.textTheme.caption,
            ),
            onChanged: (_) => _validateButton(),
          ),
          space15,
          DateTimeInput(
            onDateTimeSelected: (dateTime) {
              if (dateTime != null) {
                _selectedDate = dateTime;
              }
            },
          ),
          const Spacer(),
          SizedBox(
            height: 44,
            child: CustomButton(
              onPressed: _isAddEnable ? _addProduct : null,
              child: Text(
                'ADD',
                style: theme.textTheme.button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addProduct() {
    final product = Transaction(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      addTime: _selectedDate,
    );
    Navigator.pop(context, product);
  }

  void _validateButton() {
    setState(() {
      _isAddEnable =
          _nameController.text.isNotEmpty && _priceController.text.isNotEmpty;
    });
  }
}
