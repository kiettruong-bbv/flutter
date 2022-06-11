import 'package:expense_notes/bloc/chart/chart_cubit.dart';
import 'package:expense_notes/bloc/chart/chart_state.dart';
import 'package:expense_notes/widget/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        if (state is ChartUpdated) {
          return MyBarChart(barGroups: state.chartData);
        }
        return _buildEmptyChart();
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
