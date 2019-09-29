import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';

class Task {
  String id;
  String title;
  String description;
  double amount;
  DateTime date;
  bool flagDivider;
  var color;

  Task({
    @required this.id,
    @required this.title,
    this.description,
    @required this.amount,
    @required this.date,
    @required this.flagDivider,
    @required this.color,
  });

  Task.headerDivider({@required this.date, @required this.flagDivider});

  String get dateFormatDM {
    return DateFormat.yMd().format(this.date);
  }

  String getDateFormatDM(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  String dateFormatDayOfWeek(weekday) {
    return DateFormat.yMd().format(weekday).substring(0, 1);
  }

  Map<String, dynamic> toJson() =>
      {
        'id': this.id,
        'title': this.title,
        'description': this.description,
        'amount': this.amount,
        'date': this.getDateFormatDM(this.date),
        'flagDivider': this.flagDivider,
        'color': this.color
      };

  Task.fromJson(Map<String, dynamic> json)
      : this.id = json['id'],
        this.title = json['title'],
        this.description = json['description'],
        this.amount = json['amount'],
        this.date = json['date'],
        this.flagDivider = json['flagDivider'],
        this.color = json['color']
  ;
}
