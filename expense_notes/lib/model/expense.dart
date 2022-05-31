import 'dart:math';
import 'package:expense_notes/extension/color_extension.dart';
import 'package:flutter/material.dart';

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
        addTime = DateTime.fromMillisecondsSinceEpoch(data['addTime']);

  Expense.fromFirestoreMap(Map<String, dynamic> data)
      : id = data['fields']['id']['stringValue'],
        color = data['fields']['color']['stringValue'],
        name = data['fields']['name']['stringValue'],
        price = int.parse(data['fields']['price']['integerValue']),
        addTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(data['fields']['addTime']['integerValue']));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'color': color,
      'name': name,
      'price': price,
      'addTime': addTime.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'fields': {
        'id': {'stringValue': id},
        'color': {'stringValue': color},
        'name': {'stringValue': name},
        'price': {'integerValue': price},
        'addTime': {'integerValue': addTime.millisecondsSinceEpoch},
      },
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
