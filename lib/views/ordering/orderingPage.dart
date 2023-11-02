import 'package:flutter/material.dart';
import 'dart:async';
import 'package:order_admin/configs/constants.dart';

import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/api/bill.dart';

import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/views/components/main_layout.dart';

import 'package:order_admin/views/ordering/mobile/createBillPage.dart';
import 'package:order_admin/views/ordering/checkbills/check_bills.dart';

import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';

class RestaurantDetail {
  String id = '';
  String name = '';
  String description = '';
  List<model.Item> items = [];
  List<model.Printer> printers = [];
  List<model.Table> tables = [];
}

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

  _OrderingPageState(this.restaurantId);

  @override
  void initState() {
    super.initState();

    getRestaurant(restaurantId).then((restaurant) {
      context.read<RestaurantProvider>().setRestaurant(
          restaurant.id,
          restaurant.name,
          restaurant.description,
          restaurant.items,
          restaurant.tables);
    });

    if (mounted) {
      _timeDilationTimer?.cancel();
      _timeDilationTimer =
          Timer.periodic(const Duration(milliseconds: 3000), pollingBills);

      pollingBills(_timeDilationTimer!);
    }
  }

  pollingBills(Timer timer) {
    listBills(restaurantId, status: 'SUBMITTED').then((orders) {
      final idList = {...orders.map((e) => e.tableLabel).toList()}.toList();
      setState(() {
        hasOrdersList = idList;
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

    return MainLayout(
      centerTitle: "選擇餐桌",
      center: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('餐廳名稱：${context.read<RestaurantProvider>().name}'),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                    children: restaurant.tables
                        .map<Widget>((table) => Padding(
                              padding: const EdgeInsets.all(5),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        width: 1.0,
                                        color: context
                                                    .read<
                                                        SelectedTableProvider>()
                                                    .selectedTable
                                                    ?.label ==
                                                table.label
                                            ? kPrimaryColor
                                            : kPrimaryLightColor,
                                      ),
                                      backgroundColor:
                                          hasOrdersList.contains(table.label)
                                              ? kPrimaryLightColor
                                              : Colors.white,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<SelectedTableProvider>()
                                          .selectTable(table);

                                      listBills(restaurant.id,
                                              status: 'SUBMITTED',
                                              tableId: table.id)
                                          .then((orders) {
                                        context
                                            .read<SelectedTableProvider>()
                                            .setTableOrders(orders);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              table.label,
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
                            ))
                        .toList()),
              ),
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
