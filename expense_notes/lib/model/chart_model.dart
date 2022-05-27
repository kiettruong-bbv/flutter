import 'dart:collection';

import 'package:expense_notes/model/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartModel extends ChangeNotifier {
  List<WeekDayTransaction> _weekDayDatas = [
    WeekDayTransaction(weekDay: WeekDay.mon, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.tue, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.wed, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.thu, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.fri, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.sat, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.sun, transactions: []),
  ];

  List<BarChartGroupData> _chartData = [];

  UnmodifiableListView<BarChartGroupData> get chartData =>
      UnmodifiableListView(_chartData);

  void setupWeekDayTransactions() {
    int todayWeekDay = DateTime.now().weekday;

    if (todayWeekDay == WeekDay.sun.value) {
      return;
    }
    int todayData = _weekDayDatas
        .indexWhere((element) => element.weekDay.value == todayWeekDay);

    // Get all weekday data after today
    List<WeekDayTransaction> weekDayDataAfterToday =
        _weekDayDatas.sublist(todayData + 1);

    // Remove after-today data of current data list
    _weekDayDatas.length = _weekDayDatas.length - weekDayDataAfterToday.length;

    // Append to beginning of weekday data
    _weekDayDatas = weekDayDataAfterToday + _weekDayDatas;
  }

  void addChartData(Transaction transaction) {
    DateTime today = DateTime.now();
    DateTime day6FromToday = DateTime(today.year, today.month, today.day - 7);

    if (transaction.addTime.isAfter(day6FromToday) &&
        transaction.addTime.isBefore(today)) {
      int weekDay = transaction.addTime.weekday;
      int weekDayIndex = _weekDayDatas
          .indexWhere((element) => element.weekDay.value == weekDay);

      _weekDayDatas[weekDayIndex].transactions.add(transaction);
    }
    updateChartUI();
  }

  void editChartData(Transaction oldTrans, Transaction newTrans) {
    int oldWeekDay = oldTrans.addTime.weekday;
    int oldWeekDayIndex = _weekDayDatas
        .indexWhere((element) => element.weekDay.value == oldWeekDay);

    if (oldWeekDay == newTrans.addTime.weekday) {
      int itemIndex = _weekDayDatas[oldWeekDayIndex]
          .transactions
          .indexWhere((element) => element.id == oldTrans.id);
      _weekDayDatas[oldWeekDayIndex].transactions[itemIndex] = newTrans;
    } else {
      removeChartData(oldTrans);
      addChartData(newTrans);
    }
    updateChartUI();
  }

  void removeChartData(Transaction transaction) {
    int weekDay = transaction.addTime.weekday;
    int weekDayIndex =
        _weekDayDatas.indexWhere((element) => element.weekDay.value == weekDay);
    _weekDayDatas[weekDayIndex]
        .transactions
        .removeWhere((element) => element.id == transaction.id);
    updateChartUI();
  }

  void updateChartUI() {
    _chartData = _weekDayDatas.asMap().entries.map((entry) {
      WeekDayTransaction trans = entry.value;
      double toY = (trans.transactions.length / _weekDayDatas.length) * 10;
      return BarChartGroupData(
        x: trans.weekDay.value - 1,
        barRods: [
          BarChartRodData(
            toY: toY,
          )
        ],
      );
    }).toList();

    notifyListeners();
  }
}
