import 'package:flutter/material.dart';

enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

class Transaction {
  late final String id;
  final String name;
  final double price;
  final DateTime addTime;

  Transaction({
    required this.name,
    required this.price,
    required this.addTime,
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class DayTransaction {
  final WeekDay weekDay;
  final List<Transaction> transactions;

  DayTransaction({
    required this.weekDay,
    required this.transactions,
  });
}
