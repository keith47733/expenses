import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text('\$${transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall.copyWith(color: Colors.white)),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                onPressed: () => deleteTx(transaction.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                label: Text(
                  'Delete Tx',
                  style: Theme.of(context).textTheme.bodySmall.copyWith(
                        color: Theme.of(context).errorColor,
                      ),
                ),
              )
            : IconButton(
                onPressed: () => deleteTx(transaction.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
      ),
    );
  }
}
