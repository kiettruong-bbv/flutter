import 'package:expense_notes/extension/date_extension.dart';
import 'package:flutter/material.dart';

typedef DatePickerCallback = Function(DateTime? dateTime);

class DateTimeInput extends StatefulWidget {
  final DatePickerCallback? onSelectDateTime;

  const DateTimeInput({
    Key? key,
    this.onSelectDateTime,
  }) : super(key: key);

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        widget.onSelectDateTime?.call(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withAlpha(120),
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(selectedDate.format()),
            ),
          ),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_month),
          )
        ],
      ),
    );
  }
}
