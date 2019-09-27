import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String date;
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar(this.date, this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Column(
        children: <Widget>[
          Container(
            child: FittedBox(
              child: Text(date),
            ),
            height: constraint.maxHeight * 0.10,
          ),
          Container(
            height: constraint.maxHeight * 0.15,
            child: FittedBox(
              child: Text('${spendingAmount.toStringAsFixed(0)}H'),
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(
            height: constraint.maxHeight * 0.5,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: this.spendingAmount > 8
                          ? Colors.green
                          : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(
            child: FittedBox(
              child: Text(label),
            ),
            height: constraint.maxHeight * 0.15,
          ),
        ],
      );
    });
  }
}
