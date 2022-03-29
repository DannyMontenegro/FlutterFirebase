import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
  String title,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(title: Text(title), content: Text(text), actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ]);
    },
  );
}