import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/model/week_day_expense.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartModel {
  CollectionReference chartRef = FirebaseFirestore.instance.collection('chart');

  Future addChartData(Expense expense) async {
    checkAndAddCollectionIfNotExist();

    final DateTime today = DateTime.now();
    final DateTime day6FromToday =
        DateTime(today.year, today.month, today.day - 7);

    if (expense.addTime.isAfter(day6FromToday) &&
        expense.addTime.isBefore(today)) {
      final int weekDay = expense.addTime.weekday;

      final weekdayExpSnapshot =
          await chartRef.where('weekDay', isEqualTo: weekDay).get();
      final String docId = weekdayExpSnapshot.docs.first.reference.id;

      await chartRef.doc(docId).update({
        'expenses': FieldValue.arrayUnion([expense.toMap()])
      });
    }
  }

  Future removeChartData(Expense expense) async {
    final int weekDay = expense.addTime.weekday;

    final weekdayExpSnapshot =
        await chartRef.where('weekDay', isEqualTo: weekDay).get();
    final String docId = weekdayExpSnapshot.docs.first.reference.id;

    await chartRef.doc(docId).update({
      'expenses': FieldValue.arrayRemove([expense.toMap()])
    });
  }

  Future editChartData(Expense oldTrans, Expense newTrans) async {
    await addChartData(newTrans);
    await removeChartData(oldTrans);
  }

  List<WeekDayExpense> sortWeekDayDatas(
    List<WeekDayExpense> weekDayDatas,
  ) {
    List<WeekDayExpense> sorted = weekDayDatas;

    int todayWeekDay = DateTime.now().weekday;

    if (todayWeekDay == WeekDay.sun.value) {
      return sorted;
    }
    int todayData =
        sorted.indexWhere((element) => element.weekDay.value == todayWeekDay);

    // Get all weekday data after today
    List<WeekDayExpense> weekDayDataAfterToday = sorted.sublist(todayData + 1);

    // Remove after-today data of current data list
    sorted.length = sorted.length - weekDayDataAfterToday.length;

    // Append to beginning of weekday data
    sorted = weekDayDataAfterToday + sorted;

    return sorted;
  }

  List<BarChartGroupData> getListBarChartGroupData(
    List<WeekDayExpense> weekDayDatas,
  ) {
    return weekDayDatas.asMap().entries.map((entry) {
      WeekDayExpense wdExpense = entry.value;
      double toY = (wdExpense.expenses.length / weekDayDatas.length) * 10;
      return BarChartGroupData(
        x: wdExpense.weekDay.value - 1,
        barRods: [
          BarChartRodData(
            toY: toY,
          )
        ],
      );
    }).toList();
  }

  Future checkAndAddCollectionIfNotExist() async {
    final snapshot = await chartRef.get();
    if (snapshot.docs.isEmpty) {
      await chartRef.doc(WeekDay.mon.value.toString()).set(
            WeekDayExpense(weekDay: WeekDay.mon, expenses: []).toMap(),
          );
      await chartRef.doc(WeekDay.tue.value.toString()).set(
            WeekDayExpense(weekDay: WeekDay.tue, expenses: []).toMap(),
          );
      await chartRef.doc(WeekDay.wed.value.toString()).set(
            WeekDayExpense(weekDay: WeekDay.wed, expenses: []).toMap(),
          );
      await chartRef.doc(WeekDay.thu.value.toString()).set(
            WeekDayExpense(weekDay: WeekDay.thu, expenses: []).toMap(),
          );
      await chartRef.doc(WeekDay.fri.value.toString()).set(
            WeekDayExpense(weekDay: WeekDay.fri, expenses: []).toMap(),
          );
      await chartRef.doc(WeekDay.sat.value.toString()).set(
            WeekDayExpense(weekDay: WeekDay.sat, expenses: []).toMap(),
          );
      await chartRef.doc(WeekDay.sun.value.toString()).set(
            WeekDayExpense(weekDay: WeekDay.sun, expenses: []).toMap(),
          );
    }
  }
}
