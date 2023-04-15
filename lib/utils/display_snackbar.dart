import 'package:flutter/material.dart';

displaySnackBar(
  BuildContext context, {
  required String message,
  int duration = 5,
  Color? bgColor = Colors.white,
  Color? textColor = Colors.black,
  FontWeight? fontWeight,
  SnackBarAction? action,
}) {
  if (!ScaffoldMessenger.of(context).mounted) return;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  if (action != null || message.contains('offline')) duration = 10;

  if (message.contains('offline')) {
    bgColor = null; // use default bg color of black
    textColor = Colors.white;
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    backgroundColor: bgColor,
    margin: const EdgeInsets.all(8.0),
    padding: const EdgeInsets.all(15.0),
    behavior: SnackBarBehavior.floating,
    content: Text(message,
        style: TextStyle(color: textColor, fontWeight: fontWeight)),
    duration: Duration(seconds: duration),
    action: action,
  ));
}
