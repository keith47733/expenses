import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction(this.addTx, {Key key}) : super(key: key);

  @override
  NewTransactionState createState() => NewTransactionState();
}

class NewTransactionState extends State<NewTransaction> {
  final _txTitleController = TextEditingController();
  final _txAmountController = TextEditingController();

  DateTime _selectedDate;

  void _submitTxData() {
    final enteredTitle = _txTitleController.text;
    if (_txAmountController.text.isEmpty) {
      return;
    }
    final enteredAmount = double.parse(_txAmountController.text);

    if (enteredTitle.isNotEmpty && enteredAmount > 0 && _selectedDate != null) {
      widget.addTx(
        enteredTitle,
        enteredAmount,
        _selectedDate,
      );
      Navigator.of(context).pop(); // CLOSES TOP-MOST SHEET
    }
  }

  void _displayDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
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
              controller: _txTitleController,
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitTxData(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: _txAmountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitTxData(),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Date: No date chosen!'
                          : 'Date: ${DateFormat.yMd().format(_selectedDate)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _displayDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitTxData,
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  } // Build Widget
} // State Class
