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

  String _getJsonFormatString(dynamic v) {
    if (v == null) {
      return null;
    }
    return '"$v"';
  }

  Map<String, dynamic> toJson() =>
      {
        '"id"': _getJsonFormatString(this.id),
        '"title"': _getJsonFormatString(this.title),
        '"description"': _getJsonFormatString(this.description),
        '"amount"': this.amount,
        '"date"': _getJsonFormatString(this.getDateFormatDM(this.date)),
        '"flagDivider"': this.flagDivider,
        '"color"': _getJsonFormatString(this.color)
      };

  Task.fromJson(Map<String, dynamic> json)
      : this.id = json['id'] ?? null,
        this.title = json['title'] ?? null,
        this.description = json['description'] ?? null,
        this.amount = json['amount'] ?? null,
        this.date = json['date'],
        this.flagDivider = json['flagDivider'],
        this.color = json['color'] ?? null
  ;

  static List encodeToJson(List<Task>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toJson())
    ).toList();
    return jsonList;
  }

  static List<Task> decodeJsonToObject(dynamic jsonList){
    List<Task> taskList = [];
    jsonList.map((item)=>
        taskList.add(item.fromJson)
    ).toList();
    return taskList;
  }

}
