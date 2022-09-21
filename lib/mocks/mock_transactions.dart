import '../models/transaction.dart';

List<Transaction> mockTx() {
  List<Transaction> mockTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Groceries',
      amount: 16.53,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 't3',
      title: 'Gas',
      amount: 65.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 't4',
      title: 'Rent',
      amount: 120.00,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 't5',
      title: 'UFC PPV',
      amount: 60.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Transaction(
      id: 't6',
      title: 'Insurance',
      amount: 325.25,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
  return mockTransactions;
}
