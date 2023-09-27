import 'package:flutter/material.dart';
import 'package:order_admin/restaurantPage.dart';

class OrderingPage extends StatefulWidget {
  const OrderingPage({super.key});

  @override
  State<StatefulWidget> createState() => _OrderingPageState();
}

class _OrderingPageState extends State<OrderingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RestaurantsPage()));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
        title: const Text("點餐"),
      ),
    );
  }
}
