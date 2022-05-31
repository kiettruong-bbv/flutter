import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/widget/chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseChartScreen extends StatelessWidget {
  const ExpenseChartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: _buildChart(context),
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    return Consumer<ChartModel>(
      builder: ((context, value, child) {
        if ((value.chartData.isEmpty)) {
          return _buildEmptyChart();
        }
        return MyBarChart(barGroups: value.chartData);
      }),
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
