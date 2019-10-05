import 'package:flutter/material.dart';

import '../config/texts.dart';

class TaskForm {
  final bool isLandscape;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final TextEditingController descriptionController;
  final Function submitFx;

  TaskForm({
    this.isLandscape,
    this.titleController,
    this.amountController,
    this.descriptionController,
    this.submitFx,
  });

  List<Widget> get getForm {
    return <Widget>[
      if (isLandscape) getLandscapeMode(),
      if (!isLandscape) ...getPortraitMode(),
      TextField(
        decoration: InputDecoration(labelText: Texts.taskDescription),
        controller: this.descriptionController,
        onSubmitted: (_) => this.submitFx(),
      ),
    ];
  }

  Widget getLandscapeMode() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 10,
          child: TextField(
            decoration: InputDecoration(
              labelText: Texts.taskTitle,
              errorText: this.titleController.text.isEmpty ? Texts.requiredField : null,
            ),
            controller: this.titleController,
            onSubmitted: (_) => this.submitFx(),
          ),
        ),
        VerticalDivider(),
        Flexible(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              labelText: Texts.taskAmount,
              errorText: this.amountController.text.isEmpty ? Texts.requiredField : null,
            ),
            controller: this.amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => this.submitFx(),
          ),
        ),
      ],
    );
  }

  List<Widget> getPortraitMode() {
    return [
      TextField(
        decoration: InputDecoration(
          labelText: Texts.taskTitle,
          errorText: this.titleController.text.isEmpty ? Texts.requiredField : null,
        ),
        controller: this.titleController,
        onSubmitted: (_) => this.submitFx(),
      ),
      TextField(
        decoration: InputDecoration(
          labelText: Texts.taskAmount,
          errorText: this.amountController.text.isEmpty ? Texts.requiredField : null,
        ),
        controller: this.amountController,
        keyboardType: TextInputType.number,
      ),
    ];
  }
}
