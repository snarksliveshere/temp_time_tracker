import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../config/config_main.dart';
import '../config/texts.dart';

class AdaptiveFlatButton extends StatelessWidget {
  String text;
  Color color;
  final Function handler;

  AdaptiveFlatButton({this.text, this.color, this.handler});

  AdaptiveFlatButton.cancel(this.handler) {
    this.color = ConfigMain.appPrimaryColor;
    this.text = Texts.buttonCancel;
  }

  AdaptiveFlatButton.delete(this.handler) {
    this.color = ConfigMain.appErrorColor;
    this.text = Texts.buttonDelete;
  }

  AdaptiveFlatButton.submit(this.handler) {
    this.color = ConfigMain.appGreen;
    this.text = Texts.buttonSubmit;
  }


  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : FlatButton(
            textColor: color != null
                ? color
                : Theme.of(context).primaryColorDark,
            onPressed: handler,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

}
