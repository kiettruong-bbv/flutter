import 'package:expense_notes/bloc/chart/chart_state.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/model/week_day_expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartCubit extends Cubit<ChartState> {
  List<WeekDayExpense> _weekDayDatas = [
    WeekDayExpense(weekDay: WeekDay.mon, expenses: []),
    WeekDayExpense(weekDay: WeekDay.tue, expenses: []),
    WeekDayExpense(weekDay: WeekDay.wed, expenses: []),
    WeekDayExpense(weekDay: WeekDay.thu, expenses: []),
    WeekDayExpense(weekDay: WeekDay.fri, expenses: []),
    WeekDayExpense(weekDay: WeekDay.sat, expenses: []),
    WeekDayExpense(weekDay: WeekDay.sun, expenses: []),
  ];

  ChartCubit() : super(ChartInitial());

  void addChart(Expense expense) {
    _addChart(expense);
    populateChart();
  }

  void updateChart(Expense oldTrans, Expense newTrans) {
    _updateChart(oldTrans, newTrans);
    populateChart();
  }

  void deleteChart(Expense expense) {
    _deleteChart(expense);
    populateChart();
  }

  void initChart(List<Expense> expenses) {
    for (Expense item in expenses) {
      int weekDay = item.addTime.weekday;
      int weekDayIndex = _weekDayDatas
          .indexWhere((element) => element.weekDay.value == weekDay);
      _weekDayDatas[weekDayIndex].expenses.add(item);
    }
  }

  void sortWeekdayByToday() {
    int todayWeekDay = DateTime.now().weekday;

    if (todayWeekDay == WeekDay.sun.value) {
      return;
    }
    int todayData = _weekDayDatas
        .indexWhere((element) => element.weekDay.value == todayWeekDay);

    // Get all weekday data after today
    List<WeekDayExpense> weekDayDataAfterToday =
        _weekDayDatas.sublist(todayData + 1);

    // Remove after-today data of current data list
    _weekDayDatas.length = _weekDayDatas.length - weekDayDataAfterToday.length;

    // Append to beginning of weekday data
    _weekDayDatas = weekDayDataAfterToday + _weekDayDatas;
  }

  void populateChart() {
    final List<BarChartGroupData> chartData =
        _weekDayDatas.asMap().entries.map((entry) {
      WeekDayExpense trans = entry.value;
      double toY = (trans.expenses.length / _weekDayDatas.length) * 10;
      return BarChartGroupData(
        x: trans.weekDay.value - 1,
        barRods: [
          BarChartRodData(
            toY: toY,
          )
        ],
      );
    }).toList();

    emit(ChartUpdated(chartData: chartData));
  }

  void _addChart(Expense expense) {
    DateTime today = DateTime.now();
    DateTime day6FromToday = DateTime(today.year, today.month, today.day - 7);

    if (expense.addTime.isAfter(day6FromToday) &&
        expense.addTime.isBefore(today)) {
      int weekDay = expense.addTime.weekday;
      int weekDayIndex = _weekDayDatas
          .indexWhere((element) => element.weekDay.value == weekDay);

      _weekDayDatas[weekDayIndex].expenses.add(expense);
    }
  }

  void _deleteChart(Expense expense) {
    int weekDay = expense.addTime.weekday;
    int weekDayIndex =
        _weekDayDatas.indexWhere((element) => element.weekDay.value == weekDay);
    _weekDayDatas[weekDayIndex]
        .expenses
        .removeWhere((element) => element.id == expense.id);
  }

  void _updateChart(Expense oldTrans, Expense newTrans) {
    int oldWeekDay = oldTrans.addTime.weekday;
    int oldWeekDayIndex = _weekDayDatas
        .indexWhere((element) => element.weekDay.value == oldWeekDay);

    if (oldWeekDay == newTrans.addTime.weekday) {
      int itemIndex = _weekDayDatas[oldWeekDayIndex]
          .expenses
          .indexWhere((element) => element.id == oldTrans.id);
      _weekDayDatas[oldWeekDayIndex].expenses[itemIndex] = newTrans;
    } else {
      _deleteChart(oldTrans);
      _addChart(newTrans);
    }
  }
}
