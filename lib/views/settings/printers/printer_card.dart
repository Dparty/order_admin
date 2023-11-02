import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;

import 'package:provider/provider.dart';
import 'package:order_admin/provider/shopping_cart_provider.dart';

import '../../../components/dialog.dart';

class PrinterCard extends StatelessWidget {
  const PrinterCard({
    Key? key,
    required this.printer,
    required this.deletePrinter,
  }) : super(key: key);

  final model.Printer printer;
  final Function() deletePrinter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "名稱：${printer.name}",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    Text("SN編號：${printer.sn}"),
                    const SizedBox(height: 5),
                    Text("打印機類型：${printer.type}"),
                    const SizedBox(height: 10),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showAlertDialog(context, "確認刪除打印機${printer.name}?",
                      onConfirmed: deletePrinter);
                  // deletePrinter();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
