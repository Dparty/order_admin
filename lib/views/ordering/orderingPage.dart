import 'package:flutter/material.dart';
import 'package:order_admin/views/ordering/createBillPage.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/components/responsive.dart';
import 'package:order_admin/views/components/navbar.dart';

import 'order_detail.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'package:order_admin/provider/selection_button_provider.dart';
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
  // const OrderingPage({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _OrderingPageState(restaurantId);
  // State<StatefulWidget> createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  final String restaurantId;
  // List<model.Table> tables = [];
  // List<model.Item> items = [];
  // var restaurant;

  _OrderingPageState(this.restaurantId);

  @override
  void initState() {
    super.initState();
    // restaurant = context.read<RestaurantProvider>();
    getRestaurant(restaurantId).then((restaurant) {
      context.read<RestaurantProvider>().setRestaurant(restaurant.id,
          restaurant.name, restaurant.description, restaurant.items);
    });

    listTable(restaurantId).then((list) => setState(() {
          context.read<RestaurantProvider>().setRestaurantTables(list);
          // tables = list;
        }));
    // listItem(restaurantId).then((list) => setState(() {
    //       items = list.data;
    //     }));
  }

  void toCreateBillPage(model.Table table) {
    // final restaurant = context.watch<RestaurantProvider>();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateBillPage(
                  table: table,
                  items: context.watch()<RestaurantProvider>().items,
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
        desktop: Row(
          children: [
            const SizedBox(
              width: 200,
              child: NavBar(),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                  centerTitle: true,
                  title: const Text('選擇餐桌',
                      style:
                          TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
                ),
                body: SizedBox(
                  height: MediaQuery.of(context).size.height,
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
                                      onPressed: () {
                                        print(table.label);
                                        context
                                            .read<SelectedTableProvider>()
                                            .selectTable(table);
                                        // toCreateBillPage(table);
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
                // child: ConfigItem(itemList: items, restaurantId: restaurantId),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const VerticalDivider(),
            ),
            SizedBox(
              width: 420,
              child: OrderDetail(
                label:
                    '${context.watch<SelectedTableProvider>().selectedTable?.label}',
              ),
            ),
          ],
        ));
  }
}

// return Scaffold(
//   appBar: AppBar(
//     title: const Text("點餐"),
//   ),
//   body: Wrap(
//       children: tables
//           .map((table) => Padding(
//                 padding: const EdgeInsets.all(5),
//                 child: SizedBox(
//                   width: 100,
//                   height: 100,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       toCreateBillPage(table);
//                     },
//                     child: Text(
//                       table.label,
//                       style: const TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 24),
//                     ),
//                   ),
//                 ),
//               ))
//           .toList()),
// );
