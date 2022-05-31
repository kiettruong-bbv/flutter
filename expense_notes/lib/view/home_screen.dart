import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/view/expense_chart_screen.dart';
import 'package:expense_notes/view/expense_list_screen.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/view/expense_add_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initData();
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
              return const Center(
                child: CircularProgressIndicator(),
              );
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
    ExpenseModel expenseModel = context.read<ExpenseModel>();
    List<Expense> expenses = await expenseModel.getAll();

    ChartModel chartModel = context.read<ChartModel>();
    chartModel.sortWeekdayByToday();
    chartModel.initChart(expenses);
    chartModel.populateChart();
  }

  Future _addItem(Expense expense) async {
    ExpenseModel expenseModel = context.read<ExpenseModel>();
    await expenseModel.addItem(expense);

    ChartModel chartModel = context.read<ChartModel>();
    chartModel.addChart(expense);
  }

  Future _deleteItem(int index, Expense expense) async {
    ExpenseModel expenseModel = context.read<ExpenseModel>();
    final deletedItem = await expenseModel.deleteItem(index, expense);

    ChartModel chartModel = context.read<ChartModel>();
    chartModel.deleteChart(deletedItem);
  }

  Future _editItem(
    int index,
    Expense oldTrans,
    Expense newTrans,
  ) async {
    ExpenseModel expenseModel = context.read<ExpenseModel>();
    await expenseModel.updateItem(index, newTrans);

    ChartModel chartModel = context.read<ChartModel>();
    chartModel.updateChart(oldTrans, newTrans);
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
