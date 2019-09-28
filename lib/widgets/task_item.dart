import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({
    Key key,
    @required this.task,
    @required this.deleteTx,
    @required this.editTx,
  }) : super(key: key);

  final Task task;
  final Function deleteTx;
  final Function editTx;

  @override
  Widget build(BuildContext context) {
    return task.flagDivider
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            padding: EdgeInsets.only(bottom: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).primaryColorLight,
                    width: 1.0,
                    style: BorderStyle.solid),
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
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: CircleAvatar(
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
                  ),
                  Flexible(
                    flex: 8,
                    fit: FlexFit.tight,
                    child: Column(
                      children: <Widget>[
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.title,
                        ),
                        Text(
                          DateFormat.yMMMd().format(task.date),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      color: Theme.of(context).primaryColor,
                      onPressed: () => this.editTx(task.id),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
//                      onPressed: () => this.deleteTx(task.id),
                      onPressed: () => _showDeleteDialog(context),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  void _showDeleteDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete\n`${task.title}`?"),
          actions: <Widget>[
            FlatButton(
              child: new Text(
                "CANCEL",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                this.task.title = 'new';
              },
            ),
            FlatButton(
              child: new Text(
                "DELETE",
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                this.deleteTx(task.id);
              },
            ),
          ],
        );
      },
    );
  }
}
