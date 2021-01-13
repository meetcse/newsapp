import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MessageFlushbar {
  static showMessageFlushbar(
      BuildContext context, String title, String message, bool isError) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message != null && message.isNotEmpty) {
        Flushbar(
          title: title,
          message: message,
          backgroundColor: Color.fromARGB(150, 0, 0, 0),
          leftBarIndicatorColor: isError ? Colors.red : Colors.green,
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }
}
