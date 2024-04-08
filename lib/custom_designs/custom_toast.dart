import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Success toast message
successToast(content) {
  return Fluttertoast.showToast(
    msg: "$content 🥳",
    backgroundColor: Colors.green.shade700,
    textColor: Colors.white,
  );
}

// Fail toast message
failToast(content) {
  return Fluttertoast.showToast(
    msg: "$content 😓",
    backgroundColor: Colors.red.shade700,
    textColor: Colors.white,
  );
}

// Warn toast message
warnToast(content) {
  return Fluttertoast.showToast(
    msg: "$content 😤‍",
    backgroundColor: Colors.orange.shade800,
    textColor: Colors.white,
  );
}
