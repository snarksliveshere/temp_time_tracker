import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/texts.dart';
import '../config/config_main.dart';
import './adaptive_flat_button.dart';
import './task_form.dart';
import './color_picker.dart';
import './date_picker.dart';

class EditTask extends StatefulWidget {
  Function editTx;
  String id;
  String title;
  String description;
  double amount;
  DateTime date;
  var color;

  EditTask({this.id, this.title, this.description, this.amount, this.date,
      this.color, this.editTx});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  ColorSwatch _tempMainColor;
  dynamic _mainColor = Colors.blue;
  String _id;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _amountController.text = '${widget.amount}';
    _descriptionController.text = widget.description;
    _selectedDate = widget.date;
    _mainColor = widget.color;
    _id = widget.id;
  }

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
    widget.editTx(
      _id,
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
    TaskForm taskForm = TaskForm(
      titleController: _titleController,
      amountController: _amountController,
      descriptionController: _descriptionController,
      submitFx: _submitData,
      isLandscape: isLandscape,
    );
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
                        )),
                    Flexible(
                      flex: 3,
                      child: _selectedDate == null
                          ? Text(
                              Texts.noDateChosen,
                              style: TextStyle(
                                  color: Theme.of(context).errorColor),
                            )
                          : Text(
                              Texts.pickedDate +
                                  ' ${DateFormat.yMd().format(_selectedDate)}',
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
                child: const Text(Texts.editTask),
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
