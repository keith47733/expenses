import 'package:flutter/material.dart';

import './mocks/mock_transactions.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.green,
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = mockTx();
  //final List<Transaction> transactions = [];

  List<Transaction> get _recentTx {
    return transactions.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            const Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  void _newTxInput(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_newTx),
        );
      },
    );
  }

  void _newTx(String txTitle, double txAmount, DateTime txDate) {
    final newTxData = Transaction(
      title: txTitle,
      amount: txAmount,
      date: txDate,
      id: DateTime.now().toString(),
    );
    setState(
      () {
        transactions.add(newTxData);
      },
    );
  }

  void _deleteTx(String txID) {
    setState(
      () {
        transactions.removeWhere(
          (tx) {
            return tx.id == txID;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.blueGrey,
        title: const Text('Personal Expenses'),
        actions: [
          IconButton(
            onPressed: () => _newTxInput(context),
            icon: Image.asset(
              'assets/icons/money_bag.png',
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Image.asset(
              'assets/images/money.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
          Chart(_recentTx),
          TransactionList(transactions, _deleteTx),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[700].withOpacity(0.7),
              spreadRadius: 7,
              blurRadius: 9,
              //offset: Offset(0, 3),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.blueGrey,
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                color: Colors.transparent,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          onPressed: () => _newTxInput(context),
          child: Image.asset(
            'assets/icons/money_bag.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
