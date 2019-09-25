import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    @required this.date,
  });

//  String get dateFormatDM {
//    return DateFormat.yMd().format(this.date);
//  }

  String dateFormatDayOfWeek(weekday) {
    return DateFormat.yMd().format(weekday).substring(0, 1);
  }


}
