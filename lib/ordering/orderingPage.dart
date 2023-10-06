import 'package:flutter/material.dart';
import 'package:order_admin/ordering/createBillPage.dart';
import 'package:order_admin/ordering/shoppingCartPage.dart';
import 'package:order_admin/restaurantPage.dart';
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/models/restaurant.dart' as model;

class OrderingPage extends StatefulWidget {
  final String restaurantId;
  const OrderingPage(this.restaurantId, {super.key});
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _OrderingPageState(restaurantId);
}

class _OrderingPageState extends State<OrderingPage> {
  final String restaurantId;
  List<model.Table> tables = [];
  List<model.Item> items = [];

  _OrderingPageState(this.restaurantId);

  @override
  void initState() {
    super.initState();
    listTable(restaurantId).then((list) => setState(() {
          tables = list;
        }));
    listItem(restaurantId).then((list) => setState(() {
          items = list.data;
        }));
  }

  void toCreateBillPage(model.Table table) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateBillPage(
                  table: table,
                  items: items,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("點餐"),
      ),
      body: Wrap(
          children: tables
              .map((table) => Padding(
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
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}
