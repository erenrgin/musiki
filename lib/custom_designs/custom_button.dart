import 'package:flutter/material.dart';
import 'package:musiki/custom_designs/custom_text.dart';

// Long button
longButton(VoidCallback onPressed, String content, Color bgColor,
    BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: buttonText(content)
    ),
  );
}

// Short button
Widget shortButton({
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: 150,
    height: 45,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
