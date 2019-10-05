import 'package:flutter/material.dart';

class DatePicker {
  static Future<DateTime> returnDatePicker(BuildContext context, int numOfDays) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(
          Duration(days: numOfDays),
        ),
        lastDate: DateTime.now());
  }
}
