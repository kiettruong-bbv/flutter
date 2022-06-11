import 'package:expense_notes/bloc/chart/chart_cubit.dart';
import 'package:expense_notes/bloc/expense/expense_list_cubit.dart';
import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/view/expense/expense_add_screen.dart';
import 'package:expense_notes/view/expense/expense_chart_screen.dart';
import 'package:expense_notes/view/expense/expense_list_screen.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:expense_notes/widget/my_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future _initFuture;
  late ExpenseListCubit _expenseListCubit;
  late ChartCubit _chartCubit;

  @override
  void initState() {
    _expenseListCubit = BlocProvider.of<ExpenseListCubit>(context);
    _chartCubit = BlocProvider.of<ChartCubit>(context);
    _initFuture = _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    CupertinoThemeData iosTheme = CupertinoTheme.of(context);

    Color scaffoldBackgroundColor = isAndroid()
        ? theme.scaffoldBackgroundColor
        : iosTheme.scaffoldBackgroundColor;

    Color primaryColor =
        isAndroid() ? theme.primaryColor : iosTheme.primaryColor;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      drawer: const AppDrawer(current: Section.home),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: primaryColor,
        actions: [
          if (isIOS())
            TextButton(
              onPressed: () => _openAddExpense(),
              child: Text(
                'ADD',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: isAndroid()
          ? FloatingActionButton(
              onPressed: () => _openAddExpense(),
              child: Icon(
                Icons.add,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : null,
      body: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const MyLoader();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  flex: 3,
                  child: ExpenseChartScreen(),
                ),
                Expanded(
                  flex: 5,
                  child: _buildListContainer(),
                )
              ],
            );
          }),
    );
  }

  Widget _buildListContainer() {
    Color scaffoldBackgroundColor = isAndroid()
        ? Theme.of(context).scaffoldBackgroundColor
        : CupertinoTheme.of(context).scaffoldBackgroundColor;

    TextStyle? textStyle = isAndroid()
        ? Theme.of(context).textTheme.titleLarge
        : CupertinoTheme.of(context).textTheme.textStyle;

    return Container(
      color: scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Expense List",
            style: textStyle?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ExpenseList(
              onDelete: (index, expense) => _deleteItem(index, expense),
              onEdit: (
                mode,
                index,
                expense,
              ) =>
                  _openAddExpense(
                index: index,
                mode: mode,
                expense: expense,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _initData() async {
    await _expenseListCubit.getAll();
    List<Expense> expenses = _expenseListCubit.getExpenses();

    _chartCubit.sortWeekdayByToday();
    _chartCubit.initChart(expenses);
    _chartCubit.populateChart();
  }

  Future _addItem(Expense expense) async {
    await _expenseListCubit.addItem(expense);
    _chartCubit.addChart(expense);
  }

  Future _deleteItem(int index, Expense expense) async {
    await _expenseListCubit.deleteItem(index, expense);
    _chartCubit.deleteChart(expense);
  }

  Future _editItem(
    int index,
    Expense oldTrans,
    Expense newTrans,
  ) async {
    await _expenseListCubit.updateItem(index, newTrans);
    _chartCubit.updateChart(oldTrans, newTrans);
  }

  void _openAddExpense({
    Mode mode = Mode.add,
    int? index,
    Expense? expense,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet<Expense>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: screenHeight / 2,
            child: AddExpense(
              mode: mode,
              editedExpense: expense,
            ),
          ),
        );
      },
    ).then((newValue) {
      if (newValue != null) {
        if (mode == Mode.edit && index != null && expense != null) {
          _editItem(index, expense, newValue);
        } else {
          _addItem(newValue);
        }
      }
    });
  }
}
