import 'package:flutter/material.dart';
import 'package:order_admin/configs/constants.dart';
import 'package:order_admin/components/dialog.dart';
import 'package:order_admin/models/bill.dart';
import 'package:order_admin/models/restaurant.dart' as model;

// apis
import 'package:order_admin/api/restaurant.dart';
import 'package:order_admin/api/bill.dart';

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
    final cartProvider = context.watch<CartProvider>();

    void _showBill(orders) async {
      final List? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowCurrentBill(orders: orders);
        },
      );

      if (results != null) {}
    }

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
                        .then((value) {
                      context.read<CartProvider>().resetShoppingCart();
                      // showAlertDialog(context, "訂單已提交");
                      // todo
                      _showBill(value);
                    });
                  })),
        ),
      ]),
    );
  }
}

class ShowCurrentBill extends StatefulWidget {
  final Bill orders;
  const ShowCurrentBill({Key? key, required this.orders}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShowCurrentBillState();
}

class _ShowCurrentBillState extends State<ShowCurrentBill> {
  @override
  void initState() {
    super.initState();
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("當前帳單"),
      content: Builder(builder: (context) {
        var height = MediaQuery.of(context).size.height - 200;
        var width = MediaQuery.of(context).size.width - 800;
        return Column(
          children: [
            Container(
              width: 150,
              height: 35.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: kPrimaryColor),
              child: InkWell(
                onTap: () async {
                  await printBills([widget.orders.id], 0)
                      .then((e) => {showAlertDialog(context, "訂單已打印")});
                },
                child: const Center(
                    child: Text(
                  '打印訂單',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),
            SizedBox(
                height: height,
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: widget.orders.orders
                          .asMap()
                          .map((i, element) => MapEntry(
                              i,
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CartCardForBill(
                                  item: element.item,
                                  specification: element.specification,
                                ),
                              )))
                          .values
                          .toList()),
                ))
          ],
        );
      }),
    );
  }
}
