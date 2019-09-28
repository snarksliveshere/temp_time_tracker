import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String _text;
  Color _color;

  final Function _handler;

  AdaptiveFlatButton(this._text, this._handler);
  AdaptiveFlatButton.colorText(this._text, this._handler, this._color);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: _handler,
            child: Text(
              _text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : FlatButton(
            textColor: _color != null
                ? _color
                : Theme.of(context).primaryColorDark,
            onPressed: _handler,
            child: Text(
              _text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
