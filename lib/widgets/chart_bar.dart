import 'package:flutter/material.dart';

import '../config/config_main.dart';

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
              child: Text(spendingAmount == 0
                  ? '0'
                  : '${spendingAmount.toStringAsFixed(2)}'
              ),
            ),
          ),
          SizedBox(
            height: constraint.maxHeight * 0.05,
          ),
          Container(
            height: constraint.maxHeight * 0.5,
            width: ConfigMain.middleSpace,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ConfigMain.appGrey, width: ConfigMain.thinBorder),
                    color: ConfigMain.appLightGrey,
                    borderRadius: BorderRadius.circular(ConfigMain.middleRadius),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: this.spendingAmount > ConfigMain.numOfHours
                          ? ConfigMain.appGreen
                          : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(ConfigMain.middleRadius),
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
