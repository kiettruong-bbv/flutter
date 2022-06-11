import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

abstract class ChartState extends Equatable {
  const ChartState();

  @override
  List<Object> get props => [];
}

class ChartInitial extends ChartState {}

class ChartUpdated extends ChartState {
  final List<BarChartGroupData> chartData;

  const ChartUpdated({required this.chartData});

  @override
  List<Object> get props => [chartData];
}
