import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/model/transaction_model.dart';
import 'package:expense_notes/view/transaction_item.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:expense_notes/widget/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/transaction.dart';
import 'package:expense_notes/view/add_transaction.dart';
import 'package:provider/provider.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  @override
  void initState() {
    ChartModel chartModel = context.read<ChartModel>();
    chartModel.setupWeekDayTransactions();

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
              onPressed: () => _openAddTransaction(),
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
              onPressed: () => _openAddTransaction(),
              child: Icon(
                Icons.add,
                color: theme.colorScheme.onPrimary,
              ),
            )
          : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: _buildChart(),
          ),
          Expanded(
            flex: 5,
            child: _buildListContainer(),
          )
        ],
      ),
    );
  }

  Widget _buildChart() {
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
          child: Consumer<ChartModel>(
            builder: ((context, value, child) {
              return (value.chartData.isEmpty)
                  ? const Center(
                      child: Text(
                        'Add transaction to display chart.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : MyBarChart(
                      barGroups: value.chartData,
                    );
            }),
          ),
        ),
      ),
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
            "Transaction List",
            style: textStyle?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    TextStyle? textStyle = isAndroid()
        ? Theme.of(context).textTheme.titleLarge
        : CupertinoTheme.of(context).textTheme.textStyle;

    return Consumer<TransactionModel>(
      builder: (context, model, child) {
        List<Transaction> transactions = model.transactions;

        if (transactions.isEmpty) {
          return Center(
            child: Text(
              'No transactions added yet!',
              style: textStyle,
            ),
          );
        }

        return ListView.separated(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final item = transactions[index];
            return TransactionItem(
              key: UniqueKey(),
              index: index,
              transaction: item,
              onDelete: (index) => _removeItem(index),
              onEdit: (index) => _openAddTransaction(
                mode: Mode.edit,
                index: index,
                transaction: item,
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 15,
            );
          },
        );
      },
    );
  }

  void _addItem(Transaction transaction) {
    TransactionModel transactionModel = context.read<TransactionModel>();
    transactionModel.add(transaction);

    ChartModel chartModel = context.read<ChartModel>();
    chartModel.addChartData(transaction);
  }

  void _editItem(
    int index,
    Transaction oldTrans,
    Transaction newTrans,
  ) {
    TransactionModel transactionModel = context.read<TransactionModel>();
    transactionModel.edit(index, newTrans);

    ChartModel chartModel = context.read<ChartModel>();
    chartModel.editChartData(oldTrans, newTrans);
  }

  void _removeItem(int index) {
    TransactionModel transactionModel = context.read<TransactionModel>();
    Transaction removedTransaction = transactionModel.remove(index);

    ChartModel chartModel = context.read<ChartModel>();
    chartModel.removeChartData(removedTransaction);
  }

  void _openAddTransaction({
    Mode mode = Mode.add,
    int? index,
    Transaction? transaction,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet<Transaction>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: screenHeight / 2,
            child: AddTransaction(
              mode: mode,
              editedTransaction: transaction,
            ),
          ),
        );
      },
    ).then((newValue) {
      if (newValue != null) {
        if (mode == Mode.edit && index != null && transaction != null) {
          _editItem(index, transaction, newValue);
        } else {
          _addItem(newValue);
        }
      }
    });
  }
}
