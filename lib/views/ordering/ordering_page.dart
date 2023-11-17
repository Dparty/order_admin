import 'package:flutter/material.dart';
import 'dart:async';
import 'package:order_admin/configs/constants.dart';

import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/api/bill.dart';

import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/views/components/main_layout.dart';

import 'package:order_admin/views/ordering/mobile/create_bill_page.dart';
import 'package:order_admin/views/ordering/checkbills/check_bills.dart';

import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';

import '../../models/bill.dart';
import 'package:collection/collection.dart';

class OrderingPage extends StatefulWidget {
  final String restaurantId;
  const OrderingPage(this.restaurantId, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _OrderingPageState(restaurantId);
}

class _OrderingPageState extends State<OrderingPage> {
  final String restaurantId;
  Timer? _timeDilationTimer;
  List<String?> hasOrdersList = [];

  List<Bill>? oldOrders;
  List<String>? oldIdList;

  _OrderingPageState(this.restaurantId);

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _timeDilationTimer?.cancel();
      _timeDilationTimer =
          Timer.periodic(const Duration(milliseconds: 3000), pollingBills);

      pollingBills(_timeDilationTimer!);
    }
  }

  pollingBills(Timer timer) {
    listBills(restaurantId, status: 'SUBMITTED').then((orders) {
      oldOrders = context.read<SelectedTableProvider>().tableOrders;

      if (orders.length == oldOrders?.length) {
        oldIdList = oldOrders == null
            ? []
            : {...oldOrders!.map((e) => e.id).toList()}.toList();

        if (const IterableEquality().equals(
            {...orders.map((e) => e.id).toList()}.toList(), oldIdList)) return;
      }

      context.read<SelectedTableProvider>().setAllTableOrders(orders);
      final labelList = {...orders.map((e) => e.tableLabel).toList()}.toList();
      setState(() {
        hasOrdersList = labelList;
      });
    });
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    _timeDilationTimer = null;
    super.dispose();
  }

  void toCreateBillPage(model.Table table) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateBillPage(
                  table: table,
                  items: context.watch<RestaurantProvider>().items,
                )));
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>();
    final tableProvider = context.read<SelectedTableProvider>();

    return MainLayout(
      centerTitle: "選擇餐桌",
      center: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('餐廳名稱：${restaurant.name}'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120, //200
                      childAspectRatio: 1,
                      crossAxisSpacing: 5, // 20
                      mainAxisSpacing: 5), //20
                  itemCount: restaurant.tables.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                width: 1.0,
                                color: tableProvider.selectedTable?.label ==
                                        restaurant.tables[index].label
                                    ? kPrimaryColor
                                    : kPrimaryLightColor,
                              ),
                              backgroundColor: hasOrdersList
                                      .contains(restaurant.tables[index].label)
                                  ? kPrimaryLightColor
                                  : Colors.white,
                            ),
                            onPressed: () {
                              tableProvider
                                  .selectTable(restaurant.tables[index]);

                              // List<Bill>? bills = tableProvider.tableOrders;

                              // List<String>? selectedTableBills = bills
                              //     ?.where((i) =>
                              //         i.tableLabel == table?.label)
                              //     .toList()
                              //     .map((e) => e.id)
                              //     .toList();

                              tableProvider.setSelectedBillIds(tableProvider
                                  .tableOrders
                                  ?.where((i) =>
                                      i.tableLabel ==
                                      restaurant.tables[index]?.label)
                                  .toList()
                                  .map((e) => e.id)
                                  .toList());
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      restaurant.tables[index].label,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                    // Center(
                                    //   child: Text(
                                    //       "(${table.x.toString()},${table.y.toString()})"),
                                    // )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    );
                  }),
            ),
          ]),
      right: CheckBillsView(
          table: context.watch<SelectedTableProvider>().selectedTable,
          toOrderCallback: () {
            _timeDilationTimer?.cancel();
            _timeDilationTimer = null;
          }),
    );
  }
}
