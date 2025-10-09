import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final bool? buttonType;
  final void Function()? onPressed;
  final String title;
  const CommonButton({
    super.key,
    this.buttonType,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (buttonType == null) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.green, fontSize: 15.0),
        ),
      );
    }
    return buttonType!
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 14, 26, 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 30.0,
              ),
            ),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: TextStyle(color: Colors.green, fontSize: 16.0),
            ),
          );
  }
}
