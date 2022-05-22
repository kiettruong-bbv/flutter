import 'package:expense_notes/widget/platform_widget/platform_button.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/transaction.dart';
import 'package:expense_notes/widget/date_time_input.dart';

enum Mode { add, edit }

class AddTransaction extends StatefulWidget {
  const AddTransaction({
    Key? key,
    required this.mode,
    this.transaction,
  }) : super(key: key);

  final Mode mode;
  final Transaction? transaction;

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitEnable = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();

    _isEditing = widget.mode == Mode.edit;

    if (_isEditing) {
      Transaction? transaction = widget.transaction;
      _nameController.text = transaction?.name ?? '';
      _priceController.text = '${transaction?.price ?? 0}';
      _selectedDate = transaction?.addTime ?? DateTime.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);
    Color secondaryColor = theme.getSecondaryColor();

    const space15 = SizedBox(height: 15);

    return Container(
      padding: const EdgeInsets.all(20),
      color: theme.getBackgroundColor(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                _isEditing ? 'Edit Transaction' : 'Add Transaction',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: secondaryColor,
                ),
              ),
            ],
          ),

          space15,

          // NAME
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor,
                  width: 1,
                ),
              ),
              labelText: 'Name',
            ),
            onChanged: (_) => _validateButton(),
          ),

          space15,

          // PRICE
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor,
                  width: 1,
                ),
              ),
              labelText: 'Amount',
            ),
            onChanged: (_) => _validateButton(),
          ),

          space15,

          // DATE PICKER
          DateTimeInput(
            onDateTimeSelected: (dateTime) {
              if (dateTime != null) {
                _selectedDate = dateTime;
              }
            },
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: PlatformButton(
              onPressed: _isSubmitEnable ? _submitTransaction : null,
              child: Text(
                _isEditing ? 'EDIT' : 'ADD',
                style: theme.getButtonTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitTransaction() {
    final product = Transaction(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      addTime: _selectedDate,
    );
    Navigator.pop(context, product);
  }

  void _validateButton() {
    setState(() {
      _isSubmitEnable =
          _nameController.text.isNotEmpty && _priceController.text.isNotEmpty;
    });
  }
}
