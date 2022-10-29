import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Transactions added yet!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: constraints.maxHeight * 0.60,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView( // Note: There is a bug in ListView.builder w keys
            children: transactions
                .map(
                  ((tx) => TransactionItem(
										key: ValueKey(tx.id),
										// UniqueKey() creates unique key for each item for top-most widget
										// (every time parent widget is re-built!!)
                    transaction: tx,
                    deleteTx: deleteTx,
                  )
                )).toList(),
          );
  }
}
