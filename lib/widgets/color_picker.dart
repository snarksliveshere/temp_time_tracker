import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../config/texts.dart';
import '../config/config_main.dart';
import './adaptive_flat_button.dart';

class ColorPicker {
  final Function cancelFx;
  final Function submitFx;
  final Function onColorChange;
  final Color tempColor;
  final Color mainColor;
  final BuildContext context;

 const ColorPicker({
    @required this.cancelFx,
    @required this.submitFx,
    @required this.onColorChange,
    @required this.tempColor,
    @required this.mainColor,
    @required this.context,
  });

  void _openColorPickerDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(ConfigMain.smallSpace),
          title: Text(title),
          content: content,
          actions: [
            AdaptiveFlatButton.cancel(cancelFx),
            AdaptiveFlatButton.submit(submitFx),
          ],
        );
      },
    );
  }

  void openMainColorPicker() async {
    _openColorPickerDialog(
      Texts.colorPickerTitle,
      MaterialColorPicker(
        selectedColor: this.mainColor,
        allowShades: false,
        onMainColorChange: onColorChange,
      ),
    );
  }
}