import 'dart:math';

import 'package:flutter/material.dart';

enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

extension CatExtension on WeekDay {
  int get value {
    switch (this) {
      case WeekDay.mon:
        return 1;
      case WeekDay.tue:
        return 2;
      case WeekDay.wed:
        return 3;
      case WeekDay.thu:
        return 4;
      case WeekDay.fri:
        return 5;
      case WeekDay.sat:
        return 6;
      case WeekDay.sun:
        return 7;
    }
  }
}

class Transaction {
  late final String id;
  late final Color color;

  final String name;
  final double price;
  final DateTime addTime;

  Transaction({
    required this.name,
    required this.price,
    required this.addTime,
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    color = _generateRandomColor();
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
      1,
    );
  }
}

class WeekDayTransaction {
  final WeekDay weekDay;
  final List<Transaction> transactions;

  WeekDayTransaction({
    required this.weekDay,
    required this.transactions,
  });
}
