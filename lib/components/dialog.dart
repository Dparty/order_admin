import 'package:flutter/material.dart';

Future<bool?> showAlertDialog(BuildContext context, String text) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("提示"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(text),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("關閉"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
