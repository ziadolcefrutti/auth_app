import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';

class Utils {
  static void flushBarErrorMessage(message, context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        key: const Key('flushbar'),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        forwardAnimationCurve: Curves.decelerate,
        reverseAnimationCurve: Curves.easeOut,
        backgroundColor: Colors.red,
        titleColor: Theme.of(context).colorScheme.onTertiary,
        duration: Duration(seconds: 3),
        borderRadius: BorderRadius.circular(10),
        icon: Icon(Icons.error, size: 20, key: Key('flushbar_icon')),
        flushbarPosition: FlushbarPosition.TOP,
        message: message,
      )..show(context),
    );
  }
}
