import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String format({String pattern = 'MMM dd, yyyy'}) {
    return DateFormat(pattern).format(this);
  }
}
