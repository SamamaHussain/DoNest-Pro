import 'package:flutter/material.dart';

String pickColor(BuildContext context, String noteId) {
  String selectedColor = Colors.white30.value.toString(); // Default color
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Pick a color'),
      content: Wrap(
        children: [
          GestureDetector(
            onTap: () {
              // Update note color to red
              // updateNoteColor(noteId, Colors.red.value);
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 20,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              // Update note color to blue
              selectedColor = Colors.blue[100]!.value.toString();
;
              // updateNoteColor(noteId, Colors.blue.value);
              // Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 20,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              // Update note color to green
              selectedColor = Colors.blue[100]!.value.toString();
              // updateNoteColor(noteId, Colors.green.value);
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 20,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              // Update note color to yellow
              selectedColor = Colors.yellow[100]!.value.toString();
              // updateNoteColor(noteId, Colors.yellow.value);
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: 20,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              // Update note color to purple
              selectedColor = Colors.purple[100]!.value.toString();
              // updateNoteColor(noteId, Colors.purple.value);
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.purple,
              radius: 20,
            ),
          ),
        ],
      ),
    ),
  );
  return selectedColor; // Return the selected color value
}
