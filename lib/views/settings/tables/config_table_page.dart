import 'dart:html';

import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';

import 'package:order_admin/api/restaurant.dart';

import 'package:order_admin/models/restaurant.dart' as model;

import 'package:order_admin/views/ordering/mobile/create_bill_page.dart';
import 'package:order_admin/views/settings/tables/table_info.dart';

import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';

import 'package:order_admin/components/responsive.dart';
import 'package:order_admin/views/components/main_layout.dart';
import 'package:screenshot/screenshot.dart';

class ConfigTablePage extends StatefulWidget {
  final String restaurantId;
  const ConfigTablePage(this.restaurantId, {super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _ConfigTablePageState(restaurantId);
}

class _ConfigTablePageState extends State<ConfigTablePage> {
  final String restaurantId;
  List<String?> hasOrdersList = [];

  final events = [];
  bool canScroll = true;

  _ConfigTablePageState(this.restaurantId);

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

    return Responsive(
        mobile: Scaffold(
          appBar: AppBar(
            title: const Text("點餐"),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                  children: context
                      .watch<RestaurantProvider>()
                      .tables
                      .map<Widget>((table) => Padding(
                            padding: const EdgeInsets.all(5),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: OutlinedButton(
                                onPressed: () {
                                  toCreateBillPage(table);
                                },
                                child: Text(
                                  table.label,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ),
                            ),
                          ))
                      .toList()),
            ),
          ),
        ),
        desktop: MainLayout(
          centerTitle: "選擇餐桌",
          center: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('餐廳名稱：${context.read<RestaurantProvider>().name}'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: SizedBox(
                      height: 30,
                      width: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC88D67),
                          elevation: 0,
                        ),
                        onPressed: () {
                          context
                              .read<SelectedTableProvider>()
                              .resetSelectTable();
                        },
                        child: const Text("新增餐桌"),
                      ),
                    ),
                  )
                ],
              ),
              restaurantId != '1716465010659561472'
                  ? SizedBox(
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
                                              backgroundColor: hasOrdersList
                                                      .contains(table.label)
                                                  ? kPrimaryLightColor
                                                  : Colors.white,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<SelectedTableProvider>()
                                                  .selectTable(table);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      table.label,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                    )
                  : Expanded(
                      child: SizedBox(
                        // height: 1000,
                        // width: 1000,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: canScroll
                                ? const ScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            child: Listener(
                                onPointerDown: (event) {
                                  events.add(event.pointer);
                                },
                                onPointerUp: (event) {
                                  events.clear();
                                  setState(() {
                                    canScroll = true;
                                  });
                                },
                                onPointerMove: (event) {
                                  if (events.length == 2) {
                                    setState(() {
                                      canScroll = false;
                                    });
                                  }
                                },
                                child: SizedBox(
                                  // height: 1000,
                                  // width: 1000,
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: canScroll
                                          ? const ScrollPhysics()
                                          : const NeverScrollableScrollPhysics(),
                                      child: Listener(
                                        onPointerDown: (event) {
                                          events.add(event.pointer);
                                        },
                                        onPointerUp: (event) {
                                          events.clear();
                                          setState(() {
                                            canScroll = true;
                                          });
                                        },
                                        onPointerMove: (event) {
                                          if (events.length == 2) {
                                            setState(() {
                                              canScroll = false;
                                            });
                                          }
                                        },
                                        // height: MediaQuery.of(context).size.height - 150,
                                        child: InteractiveViewer(
                                            // constrained: false,
                                            // panEnabled: false,
                                            // panAxis: PanAxis.aligned,
                                            boundaryMargin:
                                                const EdgeInsets.all(
                                                    double.infinity),
                                            minScale: 0.2,
                                            maxScale: 1,
                                            child: SizedBox(
                                              height: 3000,
                                              width: 3000,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                            Colors.blueAccent)),
                                                child: Stack(
                                                  children: [
                                                    ...restaurant.tables
                                                        .map<Widget>(
                                                          (table) => Positioned(
                                                            left: table.x!
                                                                    .toDouble() *
                                                                100,
                                                            top: table.y!
                                                                    .toDouble() *
                                                                100,
                                                            child: SizedBox(
                                                              width: 100,
                                                              height: 100,
                                                              child:
                                                                  OutlinedButton(
                                                                      style: OutlinedButton
                                                                          .styleFrom(
                                                                        side:
                                                                            BorderSide(
                                                                          width:
                                                                              1.0,
                                                                          color: context.read<SelectedTableProvider>().selectedTable?.label == table.label
                                                                              ? kPrimaryColor
                                                                              : kPrimaryLightColor,
                                                                        ),
                                                                        backgroundColor: hasOrdersList.contains(table.label)
                                                                            ? kPrimaryLightColor
                                                                            : Colors.white,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        context
                                                                            .read<SelectedTableProvider>()
                                                                            .selectTable(table);
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                table.label,
                                                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                                                            // Container(
                                                            //   width: 20.0,
                                                            //   height: 20.0,
                                                            //   decoration: BoxDecoration(
                                                            //     shape: BoxShape.circle,
                                                            //     color: Colors.red,
                                                            //   ),
                                                            // ),
                                                          ),
                                                        )
                                                        .toList()
                                                  ],
                                                ),
                                              ),
                                            )),
                                      )),
                                ))),
                      ),
                    ),
            ],
          ),
          right: TableInfoView(
              table: context.watch<SelectedTableProvider>().selectedTable,
              reload: () => getRestaurant(restaurantId).then((restaurant) {
                    context.read<RestaurantProvider>().setRestaurant(
                        restaurant.id,
                        restaurant.name,
                        restaurant.description,
                        restaurant.items,
                        restaurant.tables);
                    context.read<SelectedTableProvider>().resetSelectTable();
                  })),
        ));
  }
}
