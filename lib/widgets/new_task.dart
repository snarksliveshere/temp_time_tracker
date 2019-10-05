import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/config_main.dart';
import '../config/texts.dart';
import './adaptive_flat_button.dart';
import './date_picker.dart';
import './color_picker.dart';
import 'task_form.dart';

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
  ColorSwatch _tempMainColor;
  ColorSwatch _mainColor = ConfigMain.appPrimaryColor;

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

  void _presentDatePicker(BuildContext context) {
    DatePicker.returnDatePicker(context, ConfigMain.numOfDays).then((val) {
      if (val == null) {
        return;
      }
      setState(() {
        _selectedDate = DateTime(val.year, val.month, val.day);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;
    ColorPicker colorPicker = ColorPicker(
      cancelFx: () => Navigator.of(context).pop(),
      context: context,
      mainColor: _mainColor,
      tempColor: _tempMainColor,
      onColorChange: (color) => setState(() => _tempMainColor = color),
      submitFx: () {
        setState(() => _mainColor = _tempMainColor);
        Navigator.of(context).pop();
      },
    );

    TaskForm taskForm = TaskForm(
      titleController: _titleController,
      amountController: _amountController,
      descriptionController: _descriptionController,
      submitFx: _submitData,
      isLandscape: isLandscape,
    );

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
              ...taskForm.getForm,
              Container(
                height: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: AdaptiveFlatButton(
                        text: Texts.chooseDate,
                        handler: () => _presentDatePicker(context),
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
                          handler: colorPicker.openMainColorPicker,
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
}
