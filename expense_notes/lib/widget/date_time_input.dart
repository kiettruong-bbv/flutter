import 'package:expense_notes/bloc/theme/theme_cubit.dart';
import 'package:expense_notes/extension/date_extension.dart';
import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/style/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef DatePickerCallback = Function(DateTime? dateTime);

class DateTimeInput extends StatefulWidget {
  final DatePickerCallback? onDateTimeSelected;

  const DateTimeInput({
    Key? key,
    this.onDateTimeSelected,
  }) : super(key: key);

  @override
  State<DateTimeInput> createState() => _DateTimeInputState();
}

class _DateTimeInputState extends State<DateTimeInput> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle? hintStyle = isAndroid()
        ? Theme.of(context).textTheme.caption
        : CupertinoTheme.of(context).textTheme.tabLabelTextStyle;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedDate.format(),
                style: hintStyle,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showDatePickerAndroid(context),
            icon: const Icon(Icons.calendar_month),
          )
        ],
      ),
    );
  }

  Future _showDatePickerAndroid(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 8),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final ThemeMode themeMode =
            BlocProvider.of<ThemeCubit>(context).currentTheme;

        if (themeMode == ThemeMode.light) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: MyColors.purple,
              ),
            ),
            child: child!,
          );
        } else if (themeMode == ThemeMode.dark) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: MyColors.lightPurple,
              ),
            ),
            child: child!,
          );
        }
        return child!;
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDateTimeSelected?.call(picked);
      });
    }
  }
}
