import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Product> items = [
    Product(100, 'Iphone'),
    Product(20, 'Shoes'),
    Product(20, 'Shoes'),
    Product(20, 'Shoes'),
    Product(20, 'Shoes'),
    Product(20, 'Shoes'),
    Product(20, 'Shoes'),
    Product(20, 'Shoes'),
    Product(20, 'Shoes')
  ];

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Notes'),
        backgroundColor: Color.fromARGB(255, 137, 100, 202),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: _buildChart(),
          ),
          Expanded(
            flex: 4,
            child: _buildTransactionList(),
          )
        ],
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      color: Colors.green,
      child: const Center(
        child: Text(
          "Chart",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Container(
      color: const Color.fromARGB(255, 248, 248, 125),
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
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) {
                return Container(height: 5);
              },
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return _buildListItem(price: item.price, name: item.name);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({required int price, required String name}) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '\$$price',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Product {
  final int price;
  final String name;
  Product(this.price, this.name);
}
