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

// WITH adds (not inherits) properties/methods from a mixin class (is not inheriting)
// Can extend from only one other class, but WITH allows multiple mixins
// to add more properties/methods
class _MyHomePageState extends State<HomePage> with WidgetsBindingObserver {
  // final List<Transaction> transactions = mockTx();
  final List<Transaction> transactions = [];

  bool showChart = true;
  bool showFAB = true;

// Create listener from WidgetsBindingObserver mixin
// WidgetsBinding.instance.addObserver(this) will run in background and call
// didChangeAppLifecycleState method if the app 'state' changes
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // This method is added by the WidgetsBindingObserver mixin, but you must
  // override to implement your own code
  // This is called whenever app life cycle changes
  // (inactive, paused, resumed, suspending)
  // This listener should always be mixed with state object and disposed
  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    print(appState);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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

  // Every widget gets its own 'context' when created
  // context is analogous to the element in the WIDGET - ELEMENT - RENDER tree
  // Contains INFO on the widget and its LOCATION in the Widget Tree
  // The contexts together create a skeleton for the widget tree!
  // We pass data down the widget tree with arguments/constructors
  //    Flutter uses context (eg, global variables for Theme, MediaQuery, etc)
  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);

    final double deviceHeight = mediaQuery.size.height;
    final double statusbarHeight = mediaQuery.padding.top;
    const double appBarHeight = 60;

    bool isPortrait;
    if (mediaQuery.orientation == Orientation.portrait) {
      isPortrait = true;
      showFAB = true;
      showChart = false;
    } else {
      isPortrait = false;
    }

    return Scaffold(
      backgroundColor: Colors.yellow[100],
      appBar: _buildAppBar(isPortrait),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isPortrait)
            ..._buildPortraitContent(deviceHeight, statusbarHeight,
                appBarHeight), // THREE DOTS SEPARATES LIST OF WIDGETS INTO INDIVIDUAL WIDGETS "FLATTENING THE LIST"
          if (!isPortrait) _buildLandscapeContent(deviceHeight, statusbarHeight, appBarHeight),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  void _newTxInput(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
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

  PreferredSizeWidget _buildAppBar(isPortrait) {
    return AppBar(
      elevation: 10,
      title: const Text('Expenses'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Visibility(
            visible: (isPortrait) ? false : true,
            replacement: const SizedBox.shrink(),
            child: _buildSwitch(),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Expenses',
          style: Theme.of(context).textTheme.bodySmall.copyWith(color: Theme.of(context).primaryColorLight),
        ),
        Switch(
          value: showChart,
          onChanged: ((value) {
            setState(() {
              if (value == true) {
                showChart = true;
                showFAB = false;
              } else {
                showChart = false;
                showFAB = true;
              }
            });
          }),
        ),
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.bodySmall.copyWith(color: Theme.of(context).primaryColorLight),
        ),
      ],
    );
  }

  List<Widget> _buildPortraitContent(deviceHeight, statusbarHeight, appBarHeight) {
    return <Widget>[
      SizedBox(
        height: (deviceHeight - statusbarHeight - appBarHeight - 50) * 0.3,
        child: Chart(_recentTx),
      ),
      SizedBox(
        height: (deviceHeight - statusbarHeight - appBarHeight - 50) * 0.7,
        child: TransactionList(transactions, _deleteTx),
      ),
    ];
  }

  Widget _buildLandscapeContent(deviceHeight, statusbarHeight, appBarHeight) {
    return showChart
        ? SizedBox(
            height: (deviceHeight - statusbarHeight - appBarHeight - 50) * 1,
            child: Chart(_recentTx),
          )
        : SizedBox(
            height: (deviceHeight - statusbarHeight - appBarHeight - 50) * 1,
            child: TransactionList(transactions, _deleteTx),
          );
  }

  Widget _buildFAB() {
    return showFAB
        ? FloatingActionButton(
            backgroundColor: Colors.transparent,
            onPressed: () => _newTxInput(context),
            child: Image.asset(
              'assets/icons/money_bag.png',
              fit: BoxFit.cover,
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildBottomBar() {
    return showChart
        ? BottomAppBar(
            color: Theme.of(context).primaryColor,
            child: Container(
              height: 50,
            ),
          )
        : Container(
            decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20)]),
            child: BottomAppBar(
              elevation: 10,
              color: Theme.of(context).primaryColor,
              shape: const CircularNotchedRectangle(),
              notchMargin: 6,
              child: Container(
                height: 50,
              ),
            ),
          );
  }
}
