import 'package:flutter/material.dart';
import 'orderItem_page.dart';
import 'package:order_admin/provider/selected_table_provider.dart';
import 'package:provider/provider.dart';
import 'cart_card.dart';

import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'package:order_admin/provider/shopping_cart_provider.dart';

class ShoppingCart extends StatelessWidget {
  ShoppingCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTable = context.watch<SelectedTableProvider>().selectedTable;
    final restaurant = context.watch<RestaurantProvider>();
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('${selectedTable?.label}的購物車',
            style: const TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
      ),
      body: ListView(children: [
        const SizedBox(height: 30.0),
        const SizedBox(height: 10.0),
        SizedBox(
            // child: Text('暫無點餐信息',
            //     style: TextStyle(color: Color(0xFF575E67), fontSize: 12.0)),
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: context
                    .watch<CartProvider>()
                    .cart
                    .asMap()
                    .map((i, element) => MapEntry(
                        i,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CartCard(item: element, index: i),
                        )))
                    .values
                    .toList())),
        const SizedBox(height: 20.0),
        Center(
          child: Text(cartProvider.getTotalPrice().toString(),
              style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF17532))),
        ),
        Center(
            child: Container(
                width: MediaQuery.of(context).size.width - 1000.0,
                height: 50.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color(0xFFC88D67)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OrderItem()));
                  },
                  child: const Center(
                      child: Text(
                    '下單',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                )))
      ]),
    );
  }
}
