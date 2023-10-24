import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/orderingQrcodePage.dart';
import '../api/restaurant.dart';

import 'SeatWidget.dart';

class TableViewWidget extends StatelessWidget {
  final String restaurantId;
  final List<model.Table> tables;
  final Function(String) delete;

  final List testTables;
  final int constrainX;
  final int constrainY;

  const TableViewWidget(this.restaurantId,
      {super.key,
      required this.tables,
      required this.delete,
      required this.constrainX,
      required this.constrainY,
      required this.testTables});
  void qrcode(BuildContext context, String tableId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderingQrcodePage(restaurantId, tableId)));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: constrainX),
      itemCount: constrainX * constrainY, // testTables.length
      itemBuilder: (context, index) {
        if (testTables.length != 0) {
          return Padding(
              padding: const EdgeInsets.all(5),
              child: getTableNumList(testTables, constrainX).contains(index)
                  ? SeatWidget(
                      searchBarText: testTables[
                                  getTableNumList(testTables, constrainX)
                                      .indexOf(index)]
                              .seatLabel ??
                          '空',
                      seatIndex: 1,
                      seatLabel: testTables[
                                  getTableNumList(testTables, constrainX)
                                      .indexOf(index)]
                              .seatLabel ??
                          '空',
                      seatType: '',
                    )
                  : SeatWidget(
                      searchBarText: '空',
                      seatIndex: 1,
                      seatLabel: '空',
                      seatType: '',
                    )

              // SeatWidget(
              //   searchBarText: testTables[index]?.seatLabel ?? '空',
              //   seatIndex: 1,
              //   seatLabel: testTables[index]?.seatLabel ?? '空',
              //   seatType: '',
              // )
              );
        } else
          return Container();
      },
    );

    // return GridView.count(
    //     crossAxisCount: 5,
    //     children:
    //         // [
    //         //   for (var i = 0; i < 10; i++){
    //         //
    //         //   }
    //         // ]
    //
    //         testTables.map((table) {
    //       return Padding(
    //           padding: const EdgeInsets.all(5),
    //           child: SeatWidget(
    //             searchBarText: table.seatLabel ?? '空',
    //             seatIndex: 1,
    //             seatLabel: table.seatLabel ?? '空',
    //             seatType: '',
    //           ));
    //     }).toList());

    return ListView(
      children: tables.map((table) {
        return
            // Row(
            // children: [
            Padding(
                padding: const EdgeInsets.all(5),
                child: SeatWidget(
                  searchBarText: table.label,
                  seatIndex: 1,
                  seatLabel: table.label,
                  seatType: '',
                ));
        //   ],
        // );
        // return Row(children: [
        //   Expanded(child: Text(table.label)),
        //   Expanded(
        //     child: IconButton(
        //         onPressed: () {
        //           qrcode(context, table.id);
        //         },
        //         icon: const Icon(Icons.qr_code)),
        //   ),
        //   IconButton(
        //       onPressed: () => delete(table.id), icon: const Icon(Icons.delete))
        // ]);
      }).toList(),
    );
  }
}

List getTableNumList(testTables, constrainX) {
  final list = [];
  for (var table in testTables) {
    list.add(((table.x - 1) * constrainX + (table.y - 1)));
  }
  return list;
}
