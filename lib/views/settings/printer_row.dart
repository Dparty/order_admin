import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/provider/restaurant_provider.dart';

class PrinterRow extends StatefulWidget {
  int index;
  List<String>? selectedPrinters;
  Function? onSelect;

  PrinterRow(
      {Key? key,
      required this.index,
      required this.selectedPrinters,
      this.onSelect})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _PrinterRow();
}

class _PrinterRow extends State<PrinterRow> {
  @override
  Widget build(BuildContext context) {
    var printers = context.watch<RestaurantProvider>().printers;
    return SizedBox(
        width: 100.0,
        child: Column(children: <Widget>[
          Expanded(
            child: DropdownButton<String>(
              value: widget.selectedPrinters?[widget.index] ?? printers[0].id,
              // : widget.selectedPrinters?[widget.index],
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                widget.onSelect!(widget.index, value);
              },
              items: printers.map<DropdownMenuItem<String>>((Printer value) {
                return DropdownMenuItem<String>(
                  value: value.id,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        ]));
  }
}
