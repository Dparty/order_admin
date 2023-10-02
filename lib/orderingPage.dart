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
        title: const Text("點餐"),
      ),
    );
  }
}
