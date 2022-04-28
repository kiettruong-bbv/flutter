import 'package:flutter/material.dart';
import 'package:expense_notes/model/transaction.dart';
import 'package:expense_notes/widget/date_time_input.dart';
import 'package:expense_notes/extension/date_extension.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
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
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Transaction',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          _buildSpace(height: 15),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
            onChanged: (_) => _validateButton(),
          ),
          _buildSpace(height: 15),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: OutlineInputBorder(),
              labelText: 'Amount',
            ),
            onChanged: (_) => _validateButton(),
          ),
          _buildSpace(height: 15),
          DateTimeInput(
            onSelectDateTime: (dateTime) {
              if (dateTime != null) {
                _selectedDate = dateTime;
              }
            },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _isAddEnable ? _addProduct : null,
            child: const Text('ADD'),
          ),
        ],
      ),
    );
  }

  Widget _buildSpace({
    double width = 0,
    double height = 0,
  }) {
    return SizedBox(
      width: width,
      height: height,
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
