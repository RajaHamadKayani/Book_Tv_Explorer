import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  static void showToast({
    required String message,
    Color backgroundColor = Colors.green,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    int toastDurationInSeconds = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      timeInSecForIosWeb: toastDurationInSeconds,
    );
  }

  static void cancelToast() {
    Fluttertoast.cancel();
  }
}