import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/config_main.dart';
import './chart_bar.dart';
import '../models/task.dart';

class Chart extends StatelessWidget {
  final List<Task> recentTasks;
  final Function scrollTo;
  MediaQueryData _mediaQuery;

  Chart(this.recentTasks, this.scrollTo);

  List<Map<String, Object>> get groupedTaskValues {
    return List.generate(30, (index) {
      final DateTime weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recentTasks.length; i++) {
        if (recentTasks[i].date.day == weekDay.day &&
            recentTasks[i].date.month == weekDay.month &&
            recentTasks[i].date.year == weekDay.year &&
            !recentTasks[i].flagDivider
        ) {
          totalSum += recentTasks[i].amount;
        }
      }

      return {
        'now' : weekDay,
        'dateDM': DateFormat.Md().format(weekDay),
        'dayOfWeek': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double _getFraction(double amount) {
    double res = amount / 24;
    if (res > 1) {
      return 1;
    }
    return res;
  }


  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    final double width = _mediaQuery.size.width - (ConfigMain.middleSpace * 4);
    final double itemWidth = width / 7;

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(ConfigMain.middleSpace),
      child: Padding(
        padding: EdgeInsets.all(ConfigMain.middleSpace),
        child:  _getRowContainerChart(itemWidth),
      ),
    );
  }

  Widget _getRowFlexibleChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ..._getFlexibleChart()
      ],
    );
  }

  Widget _getRowContainerChart(double itemWidth) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: ScrollController(
        initialScrollOffset: itemWidth * (ConfigMain.numOfDays - 7)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ..._getContainerChart(itemWidth)
        ],
      ),
    );
  }

  List<Widget> _getContainerChart(double itemWidth) {
    return groupedTaskValues.map((data) {
      return GestureDetector(
        onTap: () {
          this.scrollTo(data['now']);
        },
        child: Container(
          width: itemWidth,
          child: ChartBar(
              data['dateDM'],
              data['dayOfWeek'],
              data['amount'] as double > 24 ? 24 : data['amount'],
              _getFraction(data['amount'])
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _getFlexibleChart() {
    return groupedTaskValues.map((data) {
      return Flexible(
        fit: FlexFit.loose,
        child: ChartBar(
            data['dateDM'],
            data['dayOfWeek'],
            data['amount'] as double > 24 ? 24 : data['amount'],
            _getFraction(data['amount'])
        ),
      );
    }).toList();
  }



  _getChartViewBuilder() {
    return ListView.builder(
      itemBuilder: (context, index) {
      return Container(
        width: 25.0,
        child: ChartBar(
            groupedTaskValues[index]['dateDM'],
            groupedTaskValues[index]['dayOfWeek'],
            groupedTaskValues[index]['amount'] as double > 24
                ? 24
                : groupedTaskValues[index]['amount'],
          _getFraction(groupedTaskValues[index]['amount'])
        ),
      );
      },
      itemCount: groupedTaskValues.length,
      );
  }
}


