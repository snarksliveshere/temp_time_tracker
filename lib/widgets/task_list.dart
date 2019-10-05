import 'package:flutter/material.dart';

import '../config/config_main.dart';
import '../config/texts.dart';
import '../models/task.dart';
import './task_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function deleteTx;
  final Function editTx;
  final ScrollController scrollController;

  TaskList(this.tasks, this.deleteTx, this.editTx, this.scrollController);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: tasks.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraint) {
                return Column(
                  children: <Widget>[
                    Text(
                      Texts.noTaskAdded,
                      style: Theme.of(context).textTheme.title,
                    ),
                    const SizedBox(
                      height: ConfigMain.bigSpace,
                    ),
                    Container(
                        height: constraint.maxHeight * 0.6,
                        child: Image.asset(
                          ConfigMain.noTaskImage,
                          fit: BoxFit.cover,
                        )),
                  ],
                );
              },
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return TaskItem(task: tasks[index], deleteTx: deleteTx, editTx: editTx,);
              },
              itemCount: tasks.length,
              controller: this.scrollController,
            ),
    );
  }
}


