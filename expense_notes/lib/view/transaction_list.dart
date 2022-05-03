import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/style/config.dart';
import 'package:expense_notes/view/transaction_item.dart';
import 'package:expense_notes/widget/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/model/transaction.dart';
import 'package:expense_notes/view/add_transaction.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final List<Transaction> _transactions = [];

  final List<DayTransaction> _weekDayTransactions = [
    DayTransaction(weekDay: WeekDay.mon, transactions: []),
    DayTransaction(weekDay: WeekDay.tue, transactions: []),
    DayTransaction(weekDay: WeekDay.wed, transactions: []),
    DayTransaction(weekDay: WeekDay.thu, transactions: []),
    DayTransaction(weekDay: WeekDay.fri, transactions: []),
    DayTransaction(weekDay: WeekDay.sat, transactions: []),
    DayTransaction(weekDay: WeekDay.sun, transactions: []),
  ];

  List<BarChartGroupData> _chartData = [];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Transaction List'),
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          onPressed: () => currentTheme.toggleTheme(),
          icon: const Icon(Icons.brightness_4),
        ),
        actions: [
          if (isIOS())
            TextButton(
              style: theme.textButtonTheme.style,
              onPressed: () => _openAddTransaction(),
              child: const Text('ADD'),
            ),
        ],
      ),
      floatingActionButton: isAndroid()
          ? FloatingActionButton(
              onPressed: () => _openAddTransaction(),
              child: const Icon(Icons.add),
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
            child: _buildListContainer(context),
          )
        ],
      ),
    );
  }

  Widget _buildChart() {
    Widget chart = (_chartData.isEmpty)
        ? const Center(
            child: Text(
              'Add transaction to display chart.',
              style: TextStyle(color: Colors.white),
            ),
          )
        : MyBarChart(
            barGroups: _chartData,
          );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          child: chart,
        ),
      ),
    );
  }

  Widget _buildListContainer(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Transaction List",
            style: TextStyle(
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
    if (_transactions.isEmpty) {
      return const Center(
        child: Text('No transactions added yet!'),
      );
    }

    return ListView.separated(
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final item = _transactions[index];
        return TransactionItem(
          key: UniqueKey(),
          index: index,
          product: item,
          onDelete: (index) => _removeItem(index),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 15,
        );
      },
    );
  }

  void _removeItem(int index) {
    setState(() {
      _transactions.removeAt(index);
    });
  }

  void _addChartData(Transaction transaction) {
    DateTime today = DateTime.now();
    DateTime day7FromToday = DateTime(today.year, today.month, today.day - 8);

    if (transaction.addTime.isAfter(day7FromToday) &&
        transaction.addTime.isBefore(today)) {
      int weekDay = transaction.addTime.weekday;
      _weekDayTransactions[weekDay].transactions.add(transaction);
    }
  }

  void _updateChart() {
    _chartData = _weekDayTransactions.asMap().entries.map((entry) {
      int index = entry.key;
      DayTransaction trans = entry.value;
      double toY =
          (trans.transactions.length / _weekDayTransactions.length) * 10;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: toY,
          )
        ],
      );
    }).toList();
  }

  void _openAddTransaction() {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet<Transaction>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: screenHeight / 2,
            child: const AddTransaction(),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _transactions.add(value);
          _addChartData(value);
          _updateChart();
        });
      }
    });
  }
}
