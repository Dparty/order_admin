import 'package:flutter/material.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('餐廳列表')),
      // Inherit MaterialApp text theme and override font size and font weight.
      body: DefaultTextStyle.merge(
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(50.0),
              child: const RestaurantList(),
            ),
          )),
    );
  }
}

class RestaurantList extends StatefulWidget {
  const RestaurantList({super.key});

  @override
  State<RestaurantList> createState() => _RestaurantState();
}

class _RestaurantState extends State<RestaurantList> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("good"),
      ],
    );
  }
}
