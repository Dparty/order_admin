import 'package:flutter/material.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/views/settings/create_item_page.dart';
import 'package:order_admin/views/components/default_layout.dart';
import 'package:order_admin/views/settings/tables/config_table_page.dart';
import 'package:order_admin/views/ordering/ordering_page.dart';
import 'package:order_admin/views/settings/printers/create_printer_page.dart';
import 'package:order_admin/views/settings/printers/config_printer_page.dart';

import 'package:order_admin/create_table_page.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import '../api/restaurant.dart';
import '../configs/constants.dart';
import 'settings/printers/printers_list.dart';

import '../../components/responsive.dart';
import 'components/navbar.dart';
import 'settings/config_item_page.dart';

import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:provider/provider.dart';

class RestaurantSettingsPage extends StatefulWidget {
  final String restaurantId;
  final int? selectedNavIndex;

  const RestaurantSettingsPage(
      {super.key, required this.restaurantId, this.selectedNavIndex});

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      _RestaurantSettingsPageState(restaurantId: restaurantId);
}

class _RestaurantSettingsPageState extends State<RestaurantSettingsPage>
    with SingleTickerProviderStateMixin {
  final String restaurantId;
  model.Restaurant restaurant = const model.Restaurant(
      id: '', name: '', description: '', items: [], tables: [], categories: []);
  List<model.Item> items = [];
  List<model.Printer> printers = [];
  int _selectedIndex = 0; // for mobile bottom navigation
  int _selectedNavIndex = 0; // for desktop left bar navigation

  var scaffoldKey = GlobalKey<ScaffoldState>();

  _RestaurantSettingsPageState({required this.restaurantId});

  void loadRestaurant() {
    getRestaurant(restaurantId).then((restaurant) {
      setState(() {
        this.restaurant = restaurant;
        items = restaurant.items;
      });

      context.read<RestaurantProvider>().setRestaurant(
            restaurant.id,
            restaurant.name,
            restaurant.description,
            restaurant.items,
            restaurant.tables,
            restaurant.categories,
          );
    });
    listPrinters(restaurantId).then((list) => setState(() {
          printers = list.data;
          context.read<RestaurantProvider>().setRestaurantPrinter(list.data);
        }));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.selectedNavIndex != null) {
        _selectedNavIndex = widget.selectedNavIndex!;
      }
    });
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

  void _onNavTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
  }

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
              icon: const Icon(Icons.menu_rounded)),
        ),
        key: scaffoldKey,
        drawer: NavBar(), //drawer(context)
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            // child: TableViewWidget(
            //   restaurantId,
            //   tables: restaurant.tables,
            //   delete: removeTable,
            //   constrainX: 5,
            //   constrainY: 10,
            // )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PrintersListView(
              printersList: printers,
              reload: () =>
                  listPrinters(restaurant.id).then((list) => setState(() {
                        context
                            .read<RestaurantProvider>()
                            .setRestaurantPrinter(list.data);
                      })),
            ),
          ),
        ][_selectedIndex],

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
        floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: () => add(context),
            child: const Icon(Icons.add)),
      ),
      desktop: DefaultLayout(
        left: SizedBox(
          width: 200,
          child: NavBar(
            onTap: _onNavTapped,
            showSettings: true,
          ),
        ),
        centerTitle: ["品項設置", "餐桌設置", "打印機設置", "點餐"][_selectedNavIndex],
        center: [
          ConfigItem(),
          ConfigTablePage(restaurantId),
          const ConfigPrinter(),
          OrderingPage(restaurantId),
        ][_selectedNavIndex],
      ),
    );
  }
}
