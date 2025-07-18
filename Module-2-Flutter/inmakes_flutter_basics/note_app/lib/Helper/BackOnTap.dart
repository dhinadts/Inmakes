import 'package:flutter/material.dart';

class Backontap extends Widget {
  // const Backontap({Key? key}) : super(key: key);

  void onButtonTapped({BuildContext? context}) async {
    await Future.delayed(const Duration(seconds: 1));
    if (!context!.mounted) return;
    Backontap().onButtonTapped(context: context);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Element createElement() {
    // TODO: implement createElement
    throw UnimplementedError();
  }
}
