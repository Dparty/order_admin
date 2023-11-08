import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/create_restaurant_page.dart';
import 'package:order_admin/main.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/views/restaurant_settings_page.dart';

import '../api/restaurant.dart';
import '../api/utils.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<StatefulWidget> createState() => _RestaurantState();
}

class _RestaurantState extends State<RestaurantsPage> {
  late List<Restaurant> restaurants;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  RestaurantList restaurantList = const RestaurantList(data: []);
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    listRestaurant().then((value) {
      setState(() {
        restaurantList = value;
      });
    });
  }

  createRestaurant() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const CreateRestaurantPage();
    }));
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('餐廳列表'),
        actions: [
          IconButton(
              onPressed: () {
                signout().then((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: createRestaurant,
          child: const Icon(Icons.add)),
      body: Center(
          child: ListView.builder(
              itemCount: restaurantList.data.length,
              itemBuilder: (context, index) => RestaurantCard(
                    restaurant: restaurantList.data[index],
                    key: Key(restaurantList.data[index].id),
                  ))),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Expanded(child: Text(restaurant.name)),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantSettingsPage(
                            restaurantId: restaurant.id,
                            selectedNavIndex: 3,
                          )));
            },
            icon: const Icon(Icons.restaurant)),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantSettingsPage(
                            restaurantId: restaurant.id,
                          )));
            },
            icon: const Icon(Icons.settings))
      ]),
    );
  }
}
