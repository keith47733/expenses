import 'package:flutter/material.dart';

import 'mocks/mock_transactions.dart';
import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transaction_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final List<Transaction> transactions = mockTx();
  // final List<Transaction> transactions = [];

  bool _showChart = true;

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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceOrientation = mediaQuery.orientation;
    bool isPortrait;
    if (deviceOrientation == Orientation.portrait) {
      isPortrait = true;
    } else {
      isPortrait = false;
    }

    final appBar = AppBar(
      elevation: 10,
      // backgroundColor: Theme.of(context).primaryColor,
      title: const Text('Personal Expenses'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Visibility(
            // maintainState: true,
            // maintainAnimation: true,
            // maintainSize: true,
            visible: (isPortrait) ? false : true,
            replacement: const SizedBox.shrink(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show Expenses',
                  style: Theme.of(context).textTheme.bodySmall.copyWith(color: Theme.of(context).primaryColorLight),
                ),
                Switch(
                  value: _showChart,
                  onChanged: ((value) {
                    setState(() {
                      _showChart = value;
                    });
                  }),
                ),
                Text(
                  'Show Chart',
                  style: Theme.of(context).textTheme.bodySmall.copyWith(color: Theme.of(context).primaryColorLight),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final double deviceHeight = mediaQuery.size.height;
    final double statusbarHeight = mediaQuery.padding.top;
    final double appBarHeight = appBar.preferredSize.height;

    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPortrait)
            Column(
              children: [
                SizedBox(
                  height: (deviceHeight - statusbarHeight - appBarHeight) * 0.2,
                  width: double.maxFinite,
                  child: Image.asset(
                    'assets/images/money.jpg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  height: (deviceHeight - statusbarHeight - appBarHeight) * 0.3,
                  child: Chart(_recentTx),
                ),
                SizedBox(
                  height: (deviceHeight - statusbarHeight - appBarHeight) * 0.5,
                  child: TransactionList(transactions, _deleteTx),
                ),
              ],
            ),
          if (!isPortrait)
            _showChart
                ? SizedBox(
                    height: (deviceHeight - statusbarHeight - appBarHeight) * 1,
                    child: Chart(_recentTx),
                  )
                : SizedBox(
                    height: (deviceHeight - statusbarHeight - appBarHeight) * 1,
                    child: TransactionList(transactions, _deleteTx),
                  ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey[700].withOpacity(0.7),
      //         spreadRadius: 7,
      //         blurRadius: 9,
      //         //offset: Offset(0, 3),
      //       ),
      //     ],
      //   ),
      //   child: BottomAppBar(
      //     color: Colors.blueGrey,
      //     shape: const CircularNotchedRectangle(),
      //     child: Row(
      //       mainAxisSize: MainAxisSize.max,
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         IconButton(
      //           icon: const Icon(Icons.menu),
      //           color: Colors.transparent,
      //           onPressed: () {},
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _getFAB(isPortrait),
    );
  }

  Widget _getFAB(isPortrait) {
    return isPortrait
        ? FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () => _newTxInput(context),
            child: Image.asset(
              'assets/icons/money_bag.png',
              fit: BoxFit.cover,
            ),
          )
        : const SizedBox();
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
}
