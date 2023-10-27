import 'package:flutter/material.dart';
import './printer_card.dart';

class PrintersListView extends StatelessWidget {
  final List printersList;
  const PrintersListView({Key? key, required this.printersList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      // backgroundColor: Color(0xFFFCFAF8),
      child: ListView(children: [
        ...printersList
            .map(
              (item) => PrinterCard(
                printer: item,
              ),
            )
            .toList()
      ]),
    );
  }
}
