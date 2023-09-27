import 'package:flutter/material.dart';

class RestaurantSettingsPage extends StatefulWidget {
  final String restaurantId;
  const RestaurantSettingsPage({super.key, required this.restaurantId});

  @override
  State<StatefulWidget> createState() => _RestaurantSettingsState();
}

class _RestaurantSettingsState extends State<RestaurantSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ssd')),
    );
  }
}
