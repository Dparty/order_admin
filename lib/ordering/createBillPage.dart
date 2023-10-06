import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/ordering/shoppingCartPage.dart';
import 'package:order_admin/ordering/specificationPage.dart';

class CreateBillPage extends StatefulWidget {
  final model.Table table;
  final List<Item> items;

  const CreateBillPage({super.key, required this.items, required this.table});
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _CreateBillPageState(items, table);
}

class _CreateBillPageState extends State<CreateBillPage> {
  final model.Table table;
  final List<Item> items;
  Iterable<Specification> specifications = [];
  _CreateBillPageState(this.items, this.table);

  void toSpecificationPage(Item item) async {
    final specifications = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SpecificationPage(item)),
    ) as Iterable<Specification>?;
    if (specifications != null) {
      this.specifications = [...this.specifications, ...specifications];
    }
  }

  void toShoppingCart() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShoppingCartPage(items, specifications)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: toShoppingCart, child: const Icon(Icons.shopping_bag)),
      appBar: AppBar(
        title: Text(table.label),
      ),
      body: ItemCardList(items, toSpecificationPage),
    );
  }
}

class ItemCardList extends StatelessWidget {
  final List<Item> items;
  final void Function(Item) pressedItem;
  const ItemCardList(this.items, this.pressedItem, {super.key});

  @override
  Widget build(BuildContext context) => ListView(
      children: items
          .map((item) => ItemCard(
                item,
                onPressed: () {
                  pressedItem(item);
                },
              ))
          .toList());
}

class ItemCard extends StatelessWidget {
  final Item item;
  final void Function()? onPressed;
  const ItemCard(this.item, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(2),
        child: SizedBox(
          height: 50,
          child: OutlinedButton(
              onPressed: onPressed, child: Center(child: Text(item.name))),
        ),
      );
}
