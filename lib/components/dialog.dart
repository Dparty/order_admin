import 'package:flutter/material.dart';

Future<bool?> showDeleteConfirmDialog(BuildContext context, String text) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("提示"),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(text),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("關閉"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}
