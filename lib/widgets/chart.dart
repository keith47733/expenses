import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTx;

  const Chart(this.recentTx, {Key key}) : super(key: key);

  List<Map<String, Object>> get groupedTxValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var tx in recentTx) {
        if (tx.date.day == weekDay.day && tx.date.month == weekDay.month && tx.date.year == weekDay.year) {
          totalSum += tx.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTxValues.fold(0.0, (sum, item) {
      return sum + (item['amount']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 8.0,
        right: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.yellow[50],
            Colors.yellow[200],
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTxValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
