import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';

class ShowMessage {
  static Future<void> toast(
    String message, {
    Duration duration = const Duration(seconds: 2),
    bool isError = false,
  }) async {
    await Fluttertoast.showToast(
      msg: message,
      toastLength: duration == const Duration(seconds: 2)
          ? Toast.LENGTH_SHORT
          : Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
