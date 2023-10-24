import 'package:flutter/material.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/createItemPage.dart';
import 'package:order_admin/createPrinterPage.dart';
import 'package:order_admin/createTablePage.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/orderingQrcodePage.dart';
import '../api/restaurant.dart';

import '../restaurant-settings/TableViewWidget.dart';

import '../../components/responsive.dart';
import 'components/navbar.dart';
import 'configItemPage.dart';

import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:provider/provider.dart';

class TestTable {
  int? seatIndex;
  List? seatXY;
  String? seatType;
  String? seatLabel;
  String? status;
  int? x;
  int? y;

  TestTable({
    this.seatIndex,
    this.seatXY,
    this.seatType,
    this.seatLabel,
    this.status,
    this.x,
    this.y,
  });
}

class RestaurantSettingsPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantSettingsPage({super.key, required this.restaurantId});

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _RestaurantSettingsPageState(restaurantId: restaurantId);
}

class _RestaurantSettingsPageState extends State<RestaurantSettingsPage>
    with TickerProviderStateMixin {
  final String restaurantId;
  model.Restaurant restaurant =
      const model.Restaurant(id: '', name: '', description: '', items: []);
  List<model.Item> items = [];
  List<model.Printer> printers = [];
  List<model.Table> tables = [];
  int _selectedIndex = 0;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  _RestaurantSettingsPageState({required this.restaurantId});

  void loadRestaurant() {
    getRestaurant(restaurantId).then((restaurant) {
      setState(() {
        this.restaurant = restaurant;
        items = restaurant.items;
      });

      context.read<RestaurantProvider>().setRestaurant(restaurant.id,
          restaurant.name, restaurant.description, restaurant.items);
    });
    listPrinters(restaurantId).then((list) => setState(() {
          printers = list.data;
          context.read<RestaurantProvider>().setRestaurantPrinter(list.data);
        }));
    listTable(restaurantId).then((list) => setState(() {
          tables = list;
          context.read<RestaurantProvider>().setRestaurantTables(list);
        }));
  }

  @override
  void initState() {
    super.initState();
    loadRestaurant();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void add(BuildContext context) async {
    if (_selectedIndex == 0) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateItemPage(restaurantId),
          ));
    } else if (_selectedIndex == 1) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTablePage(restaurantId),
          ));
    } else if (_selectedIndex == 2) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePrinterPage(restaurantId),
          ));
    }
    loadRestaurant();
  }

  void removeItem(String id) {
    deleteItem(id).then((value) => loadRestaurant());
  }

  void removePrinter(String id) => deletePrinter(id)
      .then((_) => loadRestaurant())
      .onError((error, stackTrace) => showAlertDialog(context, "有品項使用此打印機"));

  void removeTable(String id) => deleteTable(id).then((_) => loadRestaurant());

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('餐廳設置', style: TextStyle(color: Colors.black)),
          leading: IconButton(
              color: Colors.black,
              onPressed: () => {scaffoldKey.currentState?.openDrawer()},
              // onPressed: () => ScaffoldKey,
              icon: Icon(Icons.menu_rounded)),
        ),
        key: scaffoldKey,
        drawer: const NavBar(), //drawer(context)
        body: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              children: [
                ...restaurant.items
                    .map(
                      (i) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(children: [
                            Expanded(child: Text(i.name)),
                            Expanded(
                                child:
                                    Text("\$${(i.pricing / 100).toString()}")),
                            ElevatedButton(
                              onPressed: () {
                                removeItem(i.id);
                              },
                              child: const Text('刪除'),
                            )
                          ])),
                    )
                    .toList()
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TableViewWidget(
                restaurantId,
                tables: tables,
                delete: removeTable,
                constrainX: 5,
                constrainY: 10,
                testTables: [
                  TestTable(seatIndex: 1, seatLabel: "桌號E", x: 1, y: 1),
                  TestTable(seatIndex: 2, seatLabel: "桌號B", x: 2, y: 1),
                  TestTable(seatIndex: 3, seatLabel: "桌號C", x: 3, y: 2)
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PrinterListWidget(printers, deletePrinter: removePrinter),
          ),
        ][_selectedIndex],
        // ListView.builder(
        //     itemCount: restaurantList.data.length,
        //     itemBuilder: (context, index) => RestaurantCard(
        //           restaurant: restaurantList.data[index],
        //           key: Key(restaurantList.data[index].id),
        //         )),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromARGB(255, 118, 148, 255),
          currentIndex: _selectedIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: '品項',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.table_bar),
              label: '餐桌',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.print),
              label: '打印機',
            ),
          ],
        ),
      ),
      desktop: Row(
        children: [
          const SizedBox(
            width: 200,
            child: NavBar(),
          ),
          Expanded(
            child: Material(
              // child: ConfigItem(itemList: items, restaurantId: restaurantId),
              child: ConfigItem(),
              // color: Colors.white,
              // child: Column(
              //   children: [
              //     Expanded(
              //         child: const SizedBox(
              //       height: 50,
              //     )),
              //     Expanded(
              //       child: ListView(
              //         scrollDirection: Axis.vertical,
              //         shrinkWrap: true,
              //         // shrinkWrap: true,
              //         children: [
              //           ...restaurant.items
              //               .map(
              //                 (i) => Padding(
              //                     padding: const EdgeInsets.all(12.0),
              //                     child: Row(children: [
              //                       Expanded(child: Text(i.name)),
              //                       Expanded(
              //                           child: Text(
              //                               "\$${(i.pricing / 100).toString()}")),
              //                       ElevatedButton(
              //                         onPressed: () {
              //                           removeItem(i.id);
              //                         },
              //                         child: const Text('刪除'),
              //                       )
              //                     ])),
              //               )
              //               .toList()
              //         ],
              //       ),
              //     )
              //   ],
              // ),
            ),
          )
        ],
      ),
    );
  }
}

class PrinterListWidget extends StatelessWidget {
  final List<model.Printer> printers;
  final Function(String) deletePrinter;
  const PrinterListWidget(
    this.printers, {
    super.key,
    required this.deletePrinter,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: printers.map((printer) {
        return PrinterCard(
            type: printer.type,
            name: printer.name,
            sn: printer.sn,
            deletePrinter: () => deletePrinter(printer.id));
      }).toList(),
    );
  }
}

class TableListWidget extends StatelessWidget {
  final String restaurantId;
  final List<model.Table> tables;
  final Function(String) delete;
  const TableListWidget(this.restaurantId,
      {super.key, required this.tables, required this.delete});
  void qrcode(BuildContext context, String tableId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderingQrcodePage(restaurantId, tableId)));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: tables.map((table) {
        return Row(children: [
          Expanded(child: Text(table.label)),
          Expanded(
            child: IconButton(
                onPressed: () {
                  qrcode(context, table.id);
                },
                icon: const Icon(Icons.qr_code)),
          ),
          IconButton(
              onPressed: () => delete(table.id), icon: const Icon(Icons.delete))
        ]);
      }).toList(),
    );
  }
}

class PrinterCard extends StatelessWidget {
  final String name;
  final String sn;
  final String type;
  final Function() deletePrinter;
  const PrinterCard(
      {super.key,
      required this.name,
      required this.sn,
      required this.deletePrinter,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Center(child: Text(name))),
        Expanded(child: Center(child: Text(sn))),
        Expanded(child: Center(child: Text(type))),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: deletePrinter,
        )
      ],
    );
  }
}

// return Scaffold(
//   floatingActionButton: FloatingActionButton(
//     onPressed: () {
//       add(context);
//     },
//     child: const Icon(Icons.add),
//   ),
//   appBar: AppBar(
//     title: Text(restaurant.name),
//   ),
//   body: <Widget>[
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: ListView(
//         children: [
//           ...restaurant.items
//               .map(
//                 (i) => Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(children: [
//                       Expanded(child: Text(i.name)),
//                       Expanded(
//                           child: Text("\$${(i.pricing / 100).toString()}")),
//                       ElevatedButton(
//                         onPressed: () {
//                           removeItem(i.id);
//                         },
//                         child: const Text('刪除'),
//                       )
//                     ])),
//               )
//               .toList()
//         ],
//       ),
//     ),
//     Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: TableViewWidget(
//           restaurantId,
//           tables: tables,
//           delete: removeTable,
//           constrainX: 5,
//           constrainY: 10,
//           testTables: [
//             TestTable(seatIndex: 1, seatLabel: "桌號E", x: 1, y: 1),
//             TestTable(seatIndex: 2, seatLabel: "桌號B", x: 2, y: 1),
//             TestTable(seatIndex: 3, seatLabel: "桌號C", x: 3, y: 2)
//           ],
//         )),
//     Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: PrinterListWidget(printers, deletePrinter: removePrinter),
//     ),
//   ][_selectedIndex],
//   bottomNavigationBar: BottomNavigationBar(
//     onTap: _onItemTapped,
//     selectedItemColor: const Color.fromARGB(255, 118, 148, 255),
//     currentIndex: _selectedIndex,
//     items: const <BottomNavigationBarItem>[
//       BottomNavigationBarItem(
//         icon: Icon(Icons.restaurant_menu),
//         label: '品項',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.table_bar),
//         label: '餐桌',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.print),
//         label: '打印機',
//       ),
//     ],
//   ),
// );

// // 菜品
// child: DefaultTextStyle.merge(
// style: const TextStyle(
// fontSize: 24,
// fontWeight: FontWeight.bold,
// ),
// child: Center(
// child: Container(
// child: Padding(
// padding: const EdgeInsets.symmetric(horizontal: 16.0),
// child: ListView(
// children: [
// ...restaurant.items
//     .map(
// (i) => Padding(
// padding: const EdgeInsets.all(12.0),
// child: Row(children: [
// Expanded(child: Text(i.name)),
// Expanded(
// child: Text(
// "\$${(i.pricing / 100).toString()}")),
// ElevatedButton(
// onPressed: () {
// removeItem(i.id);
// },
// child: const Text('刪除'),
// )
// ])),
// )
//     .toList()
// ],
// ),
// ),
// // margin: const EdgeInsets.all(150.0),
// // child: const SigninForm(),
// ),
// )
// ),
//
