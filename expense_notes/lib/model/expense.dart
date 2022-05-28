import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_notes/extension/color_extension.dart';
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

class Expense {
  late final String id;
  late final String color;

  final String name;
  final int price;
  final DateTime addTime;

  Expense({
    required this.name,
    required this.price,
    required this.addTime,
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
    color = _generateRandomColor().toHexTriplet();
  }

  Expense.full({
    required this.id,
    required this.color,
    required this.name,
    required this.price,
    required this.addTime,
  });

  Expense.update(Expense expense)
      : id = expense.id,
        color = expense.color,
        name = expense.name,
        price = expense.price,
        addTime = expense.addTime;

  Expense.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        color = data['color'],
        name = data['name'],
        price = data['price'],
        addTime = (data['addTime'] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'name': name,
      'price': price,
      'addTime': Timestamp.fromDate(addTime),
    };
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
