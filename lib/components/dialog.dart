import 'package:flutter/material.dart';

Future<bool?> showAlertDialog(BuildContext context, String text,
    {Function()? onConfirmed}) {
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
          onConfirmed != null
              ? TextButton(
                  onPressed: () {
                    onConfirmed();
                    Navigator.of(context).pop();
                  },
                  child: const Text("確認"),
                )
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
        ],
      );
    },
  );
}
