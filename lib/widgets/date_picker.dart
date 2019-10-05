import 'package:flutter/material.dart';

class DatePicker {
//  final BuildContext context;

//  DatePicker({this.context});
  static Future<DateTime> returnDatePicker(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(
          Duration(days: 30),
        ),
        lastDate: DateTime.now());
  }
}
