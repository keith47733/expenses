import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Instantiate a widget that 'extends' or inherits the properties/methods of a stateful widget
class NewTransaction extends StatefulWidget {
  final Function addTx;

  // Constructor for the widget
  NewTransaction(this.addTx, {Key key}) : super(key: key) {
    print('Constructor for NewTransaction widget');
  }

  // Creates a state object - createState() - linked to the widget
  // WIDGET - ELEMENT [STATE OBJECT] - RENDER
  @override
  NewTransactionState createState() {
    print('createState for NewTransaction widget');
    return NewTransactionState();
  }
}

// Instantiates a widget class, or STATE CLASS, that 'extends' or inherits the properties/methods of the state object which is linked to stateful widget
class NewTransactionState extends State<NewTransaction> {
  final _txTitleController = TextEditingController();
  final _txAmountController = TextEditingController();
  final _txDateController = TextEditingController();

  DateTime _selectedDate;

  // Constructor for NewTransactionState class (not required - for demo)
  NewTransactionState() {
    print('Constructor for NewTransactionState');
  }

  // Overrides the initState method inherited from the state class
  // to run our own code in method
  // Executed only when widget class is first created
  @override
  void initState() {
    // Execute your own code (eg, load data from http or server)
    print('Executed @override initState() method');
    // Super refers to parent class, in this case the state object
    // Execute 'default' initState() from parent class (mainly for debugging)
    super.initState();
  }

  // Override method in parent class (state object) to run our own code in method
  // Called when widget attached to state object changes
  @override
  void didUpdateWidget(NewTransaction oldWidget) {
    // Accepts oldWidget - the previous widget that was attached to the state object
    // so you can compare to newly instantiated widget
    // widget. refers to updated widget
    print('Executed didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  // dispose() is executed when widget is 'destroyed' and new instance is created
  // eg, when the state object changes or MediaQuery is called
	// Remove streams, listeners, controllers, etc (they can lead to strange bugs)
  @override
  void dispose() {
    print('Executed dispose()');
    super.dispose();
  }

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
