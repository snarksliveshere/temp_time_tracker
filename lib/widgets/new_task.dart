import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../config/config_main.dart';
import '../config/texts.dart';
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

  _checkValid() {
    if (_amountController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _selectedDate != null) {
      return _submitData;
    } else {
      return null;
    }
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    final enteredAmount = double.parse(_amountController.text);

    widget.addTx(
      enteredTitle,
      enteredDescription,
      enteredAmount,
      _selectedDate,
      _mainColor,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(
              Duration(days: 30),
            ),
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
            decoration: InputDecoration(
              labelText: 'Title',
              errorText: _titleController.text.isEmpty ? 'required' : null,
            ),
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
            decoration: InputDecoration(
              labelText: 'Amount',
              errorText: _amountController.text.isEmpty ? 'required' : null,
            ),
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
        decoration: InputDecoration(
          labelText: 'Title',
          errorText: _titleController.text.isEmpty ? 'required' : null,
        ),
        controller: _titleController,
        onSubmitted: (_) => _submitData(),
        // onChanged: (val) {
        //   titleInput = val;
        // },
      ),
      TextField(
        decoration: InputDecoration(
          labelText: 'Amount (hours)',
          errorText: _amountController.text.isEmpty ? 'required' : null,
        ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: AdaptiveFlatButton(
                        text: Texts.chooseDate,
                        handler: _presentDatePicker,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: _selectedDate == null
                          ? Text(
                              Texts.noDateChosen,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            )
                          : Text(
                              'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
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
                        child: AdaptiveFlatButton(
                          text: Texts.chooseColor,
                          color: ConfigMain.appWhite,
                          handler: _openMainColorPicker,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColorDark,
                child: const Text(Texts.addTask),
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _checkValid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openColorPickerDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(ConfigMain.smallSpace),
          title: Text(title),
          content: content,
          actions: [
            AdaptiveFlatButton.cancel(() => Navigator.of(context).pop()),
            AdaptiveFlatButton.submit(() {
              setState(() => _mainColor = _tempMainColor);
              Navigator.of(context).pop();
            }),
          ],
        );
      },
    );
  }

  void _openMainColorPicker() async {
    _openColorPickerDialog(
      Texts.colorPickerTitle,
      MaterialColorPicker(
        selectedColor: _mainColor,
        allowShades: false,
        onMainColorChange: (color) => setState(() => _tempMainColor = color),
      ),
    );
  }

  ColorSwatch _tempMainColor;
  ColorSwatch _mainColor = Colors.blue;
}
