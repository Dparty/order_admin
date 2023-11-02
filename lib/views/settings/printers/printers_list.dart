import 'package:flutter/material.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/api/restaurant.dart';
import 'printer_card.dart';

class PrintersListView extends StatelessWidget {
  final List printersList;
  final Function()? reload;
  final Function? onTap;
  const PrintersListView(
      {Key? key, required this.printersList, this.reload, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void removePrinter(String id) => deletePrinter(id)
        .then((_) => reload!())
        .onError((error, stackTrace) => showAlertDialog(context, "有品項使用此打印機"));

    return Container(
      child: ListView(children: [
        ...printersList
            .map(
              (item) => PrinterCard(
                printer: item,
                deletePrinter: () => removePrinter(item.id),
                onTap: () => onTap!(item),
              ),
            )
            .toList()
      ]),
    );
  }
}
