import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/widget/platform_widget/platform_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/widget/date_time_input.dart';

enum Mode { add, edit }

class AddExpense extends StatefulWidget {
  const AddExpense({
    Key? key,
    required this.mode,
    this.editedExpense,
  }) : super(key: key);

  final Mode mode;
  final Expense? editedExpense;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitEnable = false;
  bool _isEditing = false;
  Expense? _editedExpense;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();

    _isEditing = widget.mode == Mode.edit;
    if (_isEditing) {
      Expense? editedExpense = widget.editedExpense;
      _editedExpense = editedExpense;
      _nameController.text = editedExpense?.name ?? '';
      _priceController.text = '${editedExpense?.price ?? 0}';
      _selectedDate = editedExpense?.addTime ?? DateTime.now();
      _isSubmitEnable = true;
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
    const space15 = SizedBox(height: 15);

    Color backgroundColor = isAndroid()
        ? Theme.of(context).scaffoldBackgroundColor
        : CupertinoTheme.of(context).scaffoldBackgroundColor;

    Color primaryColor = isAndroid()
        ? Theme.of(context).primaryColor
        : CupertinoTheme.of(context).primaryColor;

    TextStyle? titleStyle = isAndroid()
        ? Theme.of(context).textTheme.titleLarge
        : CupertinoTheme.of(context).textTheme.navTitleTextStyle;

    TextStyle? textFieldStyle = isAndroid()
        ? Theme.of(context).textTheme.subtitle1
        : CupertinoTheme.of(context).textTheme.textStyle;

    TextStyle? hintStyle = isAndroid()
        ? Theme.of(context).textTheme.caption
        : CupertinoTheme.of(context).textTheme.tabLabelTextStyle;

    TextStyle? buttonTextStyle = isAndroid()
        ? Theme.of(context).textTheme.button
        : CupertinoTheme.of(context).textTheme.textStyle;

    return Container(
      padding: const EdgeInsets.all(20),
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                _isEditing ? 'Edit Expense' : 'Add Expense',
                style: titleStyle?.copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          space15,

          // NAME
          TextField(
            controller: _nameController,
            style: textFieldStyle?.copyWith(
              fontSize: 16,
              textBaseline: TextBaseline.alphabetic,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors.grey,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 1,
                ),
              ),
              hintText: 'Name',
              hintStyle: hintStyle,
            ),
            onChanged: (_) => _validateButton(),
          ),

          space15,

          // PRICE
          TextField(
            controller: _priceController,
            style: textFieldStyle?.copyWith(
              fontSize: 16,
              textBaseline: TextBaseline.alphabetic,
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: MyColors.grey,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 1,
                ),
              ),
              hintText: 'Amount',
              hintStyle: hintStyle,
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
            child: PlatformButton(
              onPressed: _isSubmitEnable ? _submitExpense : null,
              child: Text(
                _isEditing ? 'EDIT' : 'ADD',
                style: buttonTextStyle?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitExpense() {
    Expense newExpense = Expense(
      name: _nameController.text,
      price: int.parse(_priceController.text),
      addTime: _selectedDate,
    );
    if (_isEditing) {
      _editedExpense = Expense.full(
        id: _editedExpense?.id ?? '',
        color: _editedExpense?.color ?? '',
        name: newExpense.name,
        price: newExpense.price,
        addTime: newExpense.addTime,
      );
      Navigator.pop(context, _editedExpense);
    } else {
      Navigator.pop(context, newExpense);
    }
  }

  void _validateButton() {
    setState(() {
      _isSubmitEnable =
          _nameController.text.isNotEmpty && _priceController.text.isNotEmpty;
    });
  }
}
