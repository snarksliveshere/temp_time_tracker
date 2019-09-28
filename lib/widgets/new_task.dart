import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import './adaptive_flat_button.dart';

class NewTask extends StatefulWidget {
  final Function addTx;

  NewTask(this.addTx);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredDescription,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((val) {
      if (val == null) {
        return;
      }
      setState(() {
        _selectedDate = DateTime(val.year, val.month, val.day);
      });
    });
  }

  Widget getLandscapeMode() {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 10,
          child: TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: _titleController,
            onSubmitted: (_) => _submitData(),
            // onChanged: (val) {
            //   titleInput = val;
            // },
          ),
        ),
        VerticalDivider(),
        Flexible(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(labelText: 'Amount'),
            controller: _amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _submitData(),
            // onChanged: (val) => amountInput = val,
          ),
        ),
      ],
    );
  }

  List<Widget> getPortraitMode() {
    return [
      TextField(
        decoration: InputDecoration(labelText: 'Title'),
        controller: _titleController,
        onSubmitted: (_) => _submitData(),
        // onChanged: (val) {
        //   titleInput = val;
        // },
      ),
      TextField(
        decoration: InputDecoration(labelText: 'Amount'),
        controller: _amountController,
        keyboardType: TextInputType.number,
        onSubmitted: (_) => _submitData(),
        // onChanged: (val) => amountInput = val,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 10.0,
            right: 10.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (isLandscape) getLandscapeMode(),
              if (!isLandscape) ...getPortraitMode(),
              TextField(
                decoration: InputDecoration(labelText: 'Description'),
                controller: _descriptionController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              Container(
                height: 70.0,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child:
                          AdaptiveFlatButton('Choose date', _presentDatePicker),
                    ),
                    Flexible(
                      flex: 3,
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 20.0,
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        color: _mainColor,
                        child: AdaptiveFlatButton.colorText(
                          'Choose color',
                          _openMainColorPicker,
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColorDark,
                child: Text('Add Task'),
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            FlatButton(
              child: Text('CANCEL'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('SUBMIT'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
                setState(() => _shadeColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openDialog(
      "Main Color picker",
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  ColorSwatch _tempMainColor;
  Color _tempShadeColor;
  ColorSwatch _mainColor = Colors.blue;
  Color _shadeColor = Colors.blue[800];
}
