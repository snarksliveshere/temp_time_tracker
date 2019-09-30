import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                      'No tasks added yet!',
                      style: Theme.of(context).textTheme.title,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: constraint.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/towelie.png',
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

  Widget defaultCard(context, index) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              '\$${tasks[index].amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                tasks[index].title,
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                DateFormat.yMMMd().format(tasks[index].date),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


