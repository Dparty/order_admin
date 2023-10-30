import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';

// apis
import 'package:order_admin/api/restaurant.dart';

// providers
import 'package:provider/provider.dart';
import 'package:order_admin/provider/restaurant_provider.dart';
import 'package:order_admin/provider/shopping_cart_provider.dart';
import 'package:order_admin/provider/selected_table_provider.dart';

// components
import './cart_card.dart';
import './checkout_card.dart';
import 'package:order_admin/views/components/default_button.dart';

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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: Text('${selectedTable?.label}的購物車',
            style: const TextStyle(fontSize: 20.0, color: Color(0xFF545D68))),
      ),
      body: Column(children: [
        Expanded(
          child: SizedBox(
            height: 400,
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
                    .toList()),
          ),
        ),
        const SizedBox(height: 20.0),
        Center(
          child: SizedBox(
              height: 100,
              child: CheckoutCard(
                  totalPrice: (cartProvider.total / 100).toString(),
                  onPressed: () {
                    String tableId = selectedTable?.id ?? '';
                    createBill(tableId,
                            context.read<CartProvider>().getCartListForBill())
                        .then((value) => {});
                  })),
        ),
      ]),
    );
  }
}
