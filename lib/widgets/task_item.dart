import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    Key key,
    @required this.task,
    @required this.deleteTx,
  }) : super(key: key);

  final Task task;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return task.flagDivider
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.only(top:20.0, left: 20.0, right: 20.0),
            padding: EdgeInsets.only(bottom: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                  width: 1.0,
                  style: BorderStyle.solid
                ),
              ),
            ),
            child: Text(
              task.dateFormatDM,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Card(
            elevation: 5.0,
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 5,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: task.color,
                radius: 30.0,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      '${task.amount.toStringAsFixed(2)} H',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(
                task.title,
                style: Theme.of(context).textTheme.title,
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(task.date),
              ),
              trailing: MediaQuery.of(context).size.width > 360
                  ? FlatButton.icon(
                      onPressed: () => this.deleteTx(task.id),
                      textColor: Theme.of(context).errorColor,
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    )
                  : IconButton(
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () => this.deleteTx(task.id),
                    ),
            ),
          );
  }
}
