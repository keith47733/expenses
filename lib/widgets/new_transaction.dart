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
  final _txDateController = TextEditingController();

  DateTime _selectedDate;

  void _submitTxData() {
    String enteredTitle;
    double enteredAmount;
    DateTime enteredDate;

    if (_txTitleController.text.isEmpty) {
      return;
    } else {
      enteredTitle = _txTitleController.text;
    }

    if (_txAmountController.text.isEmpty) {
      return;
    } else {
      enteredAmount = double.parse(_txAmountController.text);
    }

    if (_txDateController.text.isEmpty) {
      return;
    } else {
      enteredDate = _selectedDate;
    }

    if (enteredTitle.isNotEmpty && enteredAmount > 0 && enteredDate != null) {
      widget.addTx(
        enteredTitle,
        enteredAmount,
        enteredDate,
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
          _txDateController.text = DateFormat.yMd().format(pickedDate);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Expense',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                  ),
                ),
                controller: _txTitleController,
                autofocus: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                // onSubmitted: (_) => _submitTxData(),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Amount',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                  ),
                ),
                controller: _txAmountController,
                autofocus: false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                // onSubmitted: (_) => _submitTxData(),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _displayDatePicker();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Choose date',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).errorColor, width: 2),
                    ),
                  ),
                  controller: _txDateController,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTxData,
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
