import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/model/week_day_expense.dart';
import 'package:expense_notes/widget/chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChartModel chartModel = context.read<ChartModel>();

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: const Color(0xff2c4260),
          child: FutureBuilder(
            future: chartModel.checkAndAddCollectionIfNotExist(),
            builder: (context, snapshot) {
              return _buildChart(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    ChartModel chartModel = context.read<ChartModel>();

    return StreamBuilder<QuerySnapshot>(
      stream: chartModel.chartRef.snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (!snapshot.hasData) {
          return _buildEmptyChart();
        }

        if (snapshot.data == null) {
          return _buildEmptyChart();
        }

        final documents = snapshot.data!.docs;

        final weekDayExpenses = documents.map((e) {
          final Map<String, dynamic> dataMap = e.data() as Map<String, dynamic>;
          return WeekDayExpense.fromMap(dataMap);
        }).toList();

        final sortedWeekDays = chartModel.sortWeekDayDatas(weekDayExpenses);
        final bargroups = chartModel.getListBarChartGroupData(sortedWeekDays);

        return MyBarChart(barGroups: bargroups);
      },
    );
  }

  Widget _buildEmptyChart() {
    return const Center(
      child: Text(
        'Add expense to display chart.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
