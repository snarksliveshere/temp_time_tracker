import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';

class Transaction {
  String id;
  String title;
  String description;
  double amount;
  DateTime date;
  bool flagDivider;

  Transaction({
    @required this.id,
    @required this.title,
    this.description,
    @required this.amount,
    @required this.date,
    @required this.flagDivider,
  });


  Transaction.headerDivider({
    @required this.date,
    @required this.flagDivider
  });

  String get dateFormatDM {
    return DateFormat.yMd().format(this.date);
  }

  String getDateFormatDM(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  String dateFormatDayOfWeek(weekday) {
    return DateFormat.yMd().format(weekday).substring(0, 1);
  }


}
