import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/models/cart_item.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/provider/shopping_cart_provider.dart';
import 'package:provider/provider.dart';

// components

class PrinterCard extends StatelessWidget {
  const PrinterCard({
    Key? key,
    required this.printer,
  }) : super(key: key);

  final model.Printer printer;

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CartProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          //set border radius more than 50% of height and width to make circle
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
                flex: 1,
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
          ],
        ),
      ),
    );
  }
}
