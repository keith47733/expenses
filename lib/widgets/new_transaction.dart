import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final txTitleController = TextEditingController();
  final txAmountController = TextEditingController();

  void _submitTxData() {
    final enteredTitle = txTitleController.text;
    final enteredAmount = double.parse(txAmountController.text);

    if (enteredTitle.isNotEmpty && enteredAmount > 0) {
      widget.addTx(
        enteredTitle,
        enteredAmount,
      );
      Navigator.of(context).pop(); // CLOSES TOP-MOST SHEET
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: txTitleController,
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitTxData(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: txAmountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitTxData(),
            ),
            ElevatedButton(
              onPressed: _submitTxData,
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
