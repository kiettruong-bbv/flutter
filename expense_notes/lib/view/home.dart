import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/view/expense_chart.dart';
import 'package:expense_notes/view/expense_list.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:expense_notes/widget/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/view/expense_add.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            flex: 3,
            child: ExpenseChart(),
          ),
          Expanded(
            flex: 5,
            child: _buildListContainer(),
          )
        ],
      ),
    );
  }

  // Widget _buildChart() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.3),
  //           spreadRadius: 2,
  //           blurRadius: 4,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     margin: const EdgeInsets.all(20),
  //     child: AspectRatio(
  //       aspectRatio: 1,
  //       child: Card(
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  //         color: const Color(0xff2c4260),
  //         child: Consumer<ChartModel>(
  //           builder: ((context, value, child) {
  //             return (value.chartData.isEmpty)
  //                 ? const Center(
  //                     child: Text(
  //                       'Add expense to display chart.',
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   )
  //                 : MyBarChart(
  //                     barGroups: value.chartData,
  //                   );
  //           }),
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
              onDelete: (documentId) => _deleteItem(documentId),
              onEdit: (
                mode,
                documentId,
                expense,
              ) =>
                  _openAddExpense(
                mode: mode,
                documentId: documentId,
                expense: expense,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _addItem(Expense expense) async {
    ExpenseModel expenseModel = context.read<ExpenseModel>();
    await expenseModel.addItem(expense);

    ChartModel chartModel = context.read<ChartModel>();
    await chartModel.addChartData(expense);
  }

  Future _editItem(
    String documentId,
    Expense oldTrans,
    Expense newTrans,
  ) async {
    ExpenseModel expenseModel = context.read<ExpenseModel>();
    await expenseModel.updateItem(documentId, newTrans);

    ChartModel chartModel = context.read<ChartModel>();
    await chartModel.editChartData(oldTrans, newTrans);
  }

  Future _deleteItem(String documentId) async {
    ExpenseModel expenseModel = context.read<ExpenseModel>();
    final deletedExpense = await expenseModel.deleteItem(documentId);

    ChartModel chartModel = context.read<ChartModel>();
    await chartModel.removeChartData(deletedExpense);
  }

  void _openAddExpense({
    Mode mode = Mode.add,
    String? documentId,
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
        if (mode == Mode.edit && documentId != null && expense != null) {
          _editItem(documentId, expense, newValue);
        } else {
          _addItem(newValue);
        }
      }
    });
  }
}
