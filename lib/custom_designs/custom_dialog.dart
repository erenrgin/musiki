import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../custom_functions/design_functions.dart';

// Loading dialog
Future<void> showProgressDialog(BuildContext context, String title) async {
  try {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 50),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  customLoad(context),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          );
        });
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

