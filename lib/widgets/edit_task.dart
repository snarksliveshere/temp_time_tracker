import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import './adaptive_flat_button.dart';

class EditTask extends StatefulWidget {
  Function editTx;
  String id;
  String title;
  String description;
  double amount;
  DateTime date;
  var color;

  EditTask(this.id, this.title, this.description, this.amount, this.date,
      this.color, this.editTx);


  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
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
          labelText: 'Amount',
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
                      child:
                          AdaptiveFlatButton('Choose date', _presentDatePicker),
                    ),
                    Flexible(
                      flex: 3,
                      child: _selectedDate == null
                          ? Text(
                              'No Date Chosen1',
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
                child: Text('Edit Task'),
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _checkValid(),
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
              child: Text(
                'CANCEL',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _mainColor = _tempMainColor);
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
  ColorSwatch _mainColor = Colors.blue;
}
