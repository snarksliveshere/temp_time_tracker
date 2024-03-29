import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../config/config_main.dart';
import '../config/texts.dart';
import '../models/task.dart';
import './adaptive_flat_button.dart';

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
    const double bigSpace = ConfigMain.bigSpace;
    return task.flagDivider
        ? Container(
            width: double.infinity,
            margin:
                EdgeInsets.only(top: bigSpace, left: bigSpace, right: bigSpace),
            padding: EdgeInsets.only(bottom: ConfigMain.smallSpace),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColorLight,
                  width: ConfigMain.thinBorder,
                  style: BorderStyle.solid,
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
        : Container(
            height: ConfigMain.taskItemHeight,
            child: Card(
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(
                vertical: ConfigMain.smallSpace,
                horizontal: ConfigMain.smallSpace,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(ConfigMain.smallSpace),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: CircleAvatar(
                        backgroundColor: task.color,
                        radius: ConfigMain.taskItemAvatar,
                        child: Padding(
                          padding: const EdgeInsets.all(ConfigMain.smallSpace),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            task.title,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                flex: 7,
                                child: Text(
                                  task.description,
                                  style: Theme.of(context).textTheme.subhead,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (task.description != '')
                                Flexible(
                                  flex: 3,
                                  child: Tooltip(
                                    message: task.description,
                                    child: Text(
                                      Texts.descriptionMore,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            DateFormat.yMMMd().format(task.date),
                            style: TextStyle(
                              fontSize: 10.0,
                            ),
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
                        onPressed: () => _showDeleteDialog(context),
                      ),
                    ),
                  ],
                ),
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
            AdaptiveFlatButton.cancel(() {
              Navigator.of(context).pop();
            }),
            AdaptiveFlatButton.delete(() {
              Navigator.of(context).pop();
              this.deleteTx(task.id);
            }),
          ],
        );
      },
    );
  }
}
