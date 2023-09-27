import 'package:flutter/material.dart';
import 'package:order_admin/createItemPage.dart';
import 'package:order_admin/createPrinterPage.dart';
import 'package:order_admin/models/restaurant.dart';
import 'api/restaurant.dart';

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
  Restaurant restaurant = const Restaurant(id: '', name: '', description: '');
  List<Item> items = [];
  List<Printer> printers = [];
  int _selectedIndex = 0;

  _RestaurantSettingsPageState({required this.restaurantId});

  void loadRestaurant() {
    getRestaurant(restaurantId).then((restaurant) {
      setState(() {
        this.restaurant = restaurant;
      });
    });
    listItem(restaurantId).then((list) {
      setState(() {
        items = list.data;
      });
    });
    listPrinters(restaurantId).then((list) => setState(() {
          printers = list.data;
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
    switch (_selectedIndex) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateItemPage(),
            ));
        break;
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateItemPage(),
            ));
        break;
      case 2:
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePrinterPage(restaurantId),
            ));
        break;
    }
    loadRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: <Widget>[
        const Column(
          children: [
            Text('2'),
            Text('3'),
          ],
        ),
        const Text('2'),
        PrinterListWidget(printers),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 0, 55, 255),
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
    );
  }
}

class PrinterListWidget extends StatelessWidget {
  final List<Printer> printers;
  const PrinterListWidget(
    this.printers, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: printers.map((printer) {
        return PrinterCard(name: printer.name, sn: printer.sn);
      }).toList(),
      // children: [PrinterCard(name: '1', sn: '2')],
    );
  }
}

class PrinterCard extends StatelessWidget {
  final String name;
  final String sn;
  const PrinterCard({super.key, required this.name, required this.sn});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Center(child: Text(name))),
        Expanded(child: Center(child: Text(sn)))
      ],
    );
  }
}
