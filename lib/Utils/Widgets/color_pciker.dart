import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void pickColor(BuildContext context, String noteId) {
  Color pickerColor = Colors.white;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Pick a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (color) {
            pickerColor = color;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final hexColor = '#${pickerColor.value.toRadixString(16).substring(2)}';
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
