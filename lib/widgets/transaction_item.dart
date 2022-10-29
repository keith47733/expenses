import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

// In this example, we changed TransactionItem from Stateless to Stateful
// in order to demonstrate randomly change the color of the circle avater in each item
// (assigned in initState()) using a Key.
// Without a Key, the sequence of colors stays the same when an item is deleted.
// A Key identifies the widget in the corresponding element with unique identifier,
// not just a widget type.
// Without a Key for each list item, from top to bottome, the list item Widget is
// removed, but the corresponding Element still sees the next list item and is not
// removed. Thus, the LAST element will be removed when it runs out of list items! 
class TransactionItem extends StatefulWidget {
	// Every widget can have a Key, but not every widget needs a Key (eg, stateless)
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);
	// super(key: key) forwards unique key to parent widget class constructor

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
	Color avatarColor;

	@override
	void initState() {
		super.initState();
		const availableColors = [Colors.red, Colors.green, Colors.blue, Colors.purple];
		avatarColor = availableColors[Random().nextInt(4)];
		// NOTE: Random().nextInt(4) will create random number with max of 4 integers
		// starting at zero => [0 1 2 3]
	}

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          // backgroundColor: Colors.green[300],
					backgroundColor: avatarColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall.copyWith(color: Colors.white)),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                onPressed: () => widget.deleteTx(widget.transaction.id),
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
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
      ),
    );
  }
}
