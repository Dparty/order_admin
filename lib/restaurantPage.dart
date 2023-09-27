import 'package:flutter/material.dart';
import 'package:order_admin/main.dart';
import 'package:order_admin/model/model.dart';
import 'package:order_admin/model/restaurant.dart';

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
      // Inherit MaterialApp text theme and override font size and font weight.
      body: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          child: Center(
              child: ListView.builder(
                  itemCount: restaurantList.data.length,
                  itemBuilder: (context, int index) {
                    return Text(restaurantList.data[index].name);
                  }))),
    );
  }
}
