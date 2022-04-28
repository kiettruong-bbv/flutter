enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

class Transaction {
  final String name;
  final double price;
  final DateTime addTime;

  Transaction({
    required this.name,
    required this.price,
    required this.addTime,
  });
}

class DayTransaction {
  final WeekDay weekDay;
  final List<Transaction> transactions;

  DayTransaction({
    required this.weekDay,
    required this.transactions,
  });
}
