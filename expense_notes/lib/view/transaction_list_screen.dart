import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/model/transaction_model.dart';
import 'package:expense_notes/view/transaction_item.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:expense_notes/widget/chart.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:fl_chart/fl_chart.dart';
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
  List<WeekDayTransaction> _weekDayDatas = [
    WeekDayTransaction(weekDay: WeekDay.mon, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.tue, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.wed, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.thu, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.fri, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.sat, transactions: []),
    WeekDayTransaction(weekDay: WeekDay.sun, transactions: []),
  ];

  List<BarChartGroupData> _chartData = [];

  @override
  void initState() {
    _setupWeekDayTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return Scaffold(
      backgroundColor: theme.getBackgroundColor(),
      drawer: const AppDrawer(current: Section.home),
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: theme.getPrimaryColor(),
        actions: [
          if (isIOS())
            TextButton(
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
      color: Theme.of(context).scaffoldBackgroundColor,
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
    return Consumer<TransactionModel>(
      builder: (context, model, child) {
        List<Transaction> transactions = model.transactions;

        if (transactions.isEmpty) {
          return const Center(
            child: Text('No transactions added yet!'),
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

  void _setupWeekDayTransactions() {
    int todayWeekDay = DateTime.now().weekday;

    if (todayWeekDay == WeekDay.sun.value) {
      return;
    }
    int todayData = _weekDayDatas
        .indexWhere((element) => element.weekDay.value == todayWeekDay);

    // Get all weekday data after today
    List<WeekDayTransaction> weekDayDataAfterToday =
        _weekDayDatas.sublist(todayData + 1);

    // Remove after-today data of current data list
    _weekDayDatas.length = _weekDayDatas.length - weekDayDataAfterToday.length;

    // Append to beginning of weekday data
    _weekDayDatas = weekDayDataAfterToday + _weekDayDatas;
  }

  void _addItem(Transaction transaction) {
    TransactionModel model =
        Provider.of<TransactionModel>(context, listen: false);
    model.add(transaction);
    _addChartData(transaction);
    _updateChartUI();
  }

  void _editItem(int index, Transaction transaction) {
    TransactionModel model =
        Provider.of<TransactionModel>(context, listen: false);
    model.update(index, transaction);
    _updateChartData(transaction);
    _updateChartUI();
  }

  void _removeItem(int index) {
    TransactionModel model =
        Provider.of<TransactionModel>(context, listen: false);
    Transaction removedTransaction = model.remove(index);
    _removeChartData(removedTransaction);

    setState(() {
      _updateChartUI();
    });
  }

  void _addChartData(Transaction transaction) {
    DateTime today = DateTime.now();
    DateTime day6FromToday = DateTime(today.year, today.month, today.day - 7);

    if (transaction.addTime.isAfter(day6FromToday) &&
        transaction.addTime.isBefore(today)) {
      int weekDay = transaction.addTime.weekday;
      int weekDayIndex = _weekDayDatas
          .indexWhere((element) => element.weekDay.value == weekDay);

      _weekDayDatas[weekDayIndex].transactions.add(transaction);
    }
  }

  void _updateChartData(Transaction transaction) {
    int weekDay = transaction.addTime.weekday;
    int weekDayIndex =
        _weekDayDatas.indexWhere((element) => element.weekDay.value == weekDay);
    int itemIndex = _weekDayDatas[weekDayIndex]
        .transactions
        .indexWhere((element) => element.id == transaction.id);
    _weekDayDatas[weekDayIndex].transactions[itemIndex] = transaction;
  }

  void _removeChartData(Transaction transaction) {
    int weekDay = transaction.addTime.weekday;
    int weekDayIndex =
        _weekDayDatas.indexWhere((element) => element.weekDay.value == weekDay);
    _weekDayDatas[weekDayIndex]
        .transactions
        .removeWhere((element) => element.id == transaction.id);
  }

  void _updateChartUI() {
    _chartData = _weekDayDatas.asMap().entries.map((entry) {
      WeekDayTransaction trans = entry.value;
      double toY = (trans.transactions.length / _weekDayDatas.length) * 10;
      return BarChartGroupData(
        x: trans.weekDay.value - 1,
        barRods: [
          BarChartRodData(
            toY: toY,
          )
        ],
      );
    }).toList();
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
              transaction: transaction,
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        if (mode == Mode.edit && index != null) {
          _editItem(index, value);
        } else {
          _addItem(value);
        }
      }
    });
  }
}
