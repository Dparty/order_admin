import 'package:flutter/material.dart';
import 'package:order_admin/createItemPage.dart';
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

  void add(BuildContext context) {
    switch (_selectedIndex) {
      case 0:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateItemPage(),
            ));
      case 1:
      case 2:
    }
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
            Text('2'),
            Text('3'),
          ],
        ),
        const Text('2'),
        const Text('3'),
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
