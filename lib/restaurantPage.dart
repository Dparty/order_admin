import 'package:flutter/material.dart';
import 'package:order_admin/createRestaurantPage.dart';
import 'package:order_admin/main.dart';
import 'package:order_admin/models/model.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/orderingPage.dart';
import 'package:order_admin/restaurantSettingsPage.dart';

import 'api/restaurant.dart';
import 'api/utils.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key});

  @override
  State<StatefulWidget> createState() => _RestaurantState();
}

class _RestaurantState extends State<RestaurantsPage> {
  late List<Restaurant> restaurants;
  RestaurantList restaurantList = const RestaurantList(
      pagination: Pagination(index: 0, limit: 0, total: 0), data: []);
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
        title: const Text('餐廳列表'),
        actions: [
          IconButton(
              onPressed: () {
                signout().then((_) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: createRestaurant, child: const Icon(Icons.add)),
      // Inherit MaterialApp text theme and override font size and font weight.
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
    return Row(children: [
      Expanded(child: Text(restaurant.name)),
      IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const OrderingPage()));
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
    ]);
  }
}
