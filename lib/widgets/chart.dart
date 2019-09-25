import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    print(recentTransactions.toString());
    return List.generate(7, (index) {
      final DateTime weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double amount = 0.0;
      if (recentTransactions.length >= index + 1) {
        amount = recentTransactions[index].amount;
      }

      return {
        'dateDM': DateFormat.Md().format(weekDay),
        'dayOfWeek': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': amount,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues.toString());
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['dateDM'],
                data['dayOfWeek'],
                data['amount'],
                0.8
//                totalSpending == 0.0 || totalSpending > 24
//                    ? 0.0
//                    : (data['amount'] as double) / 24,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
