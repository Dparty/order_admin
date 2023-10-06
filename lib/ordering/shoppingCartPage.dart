import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';

class ShoppingCartPage extends StatelessWidget {
  final Iterable<Item> items;
  final Iterable<Specification> specifications;

  const ShoppingCartPage(this.items, this.specifications, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("品項")),
      body: ListView(
          children: specifications.map((s) {
        final item = items.firstWhere((i) => i.id == s.itemId);
        return Row(children: [
          Padding(
            padding: const EdgeInsets.all(2),
            child: Text(item.name),
          ),
          ...s.options.map((o) => Padding(
              padding: const EdgeInsets.all(2),
              child: Text("${o.left}:${o.right}"))),
          Padding(
              padding: const EdgeInsets.all(2),
              child: ElevatedButton(onPressed: () {}, child: const Text("刪除")))
        ]);
      }).toList()),
    );
  }
}

class Order {
  final int number;
  final Item item;
  final Specification specification;

  bool match(Specification specification) {
    if (item.id != specification.itemId) return false;
    for (var option in specification.options) {
      if (option.right !=
          this
              .specification
              .options
              .firstWhere((o) => o.left == option.left)
              .right) {
        return false;
      }
    }
    return true;
  }

  Order(
      {required this.number, required this.item, required this.specification});
}

Iterable<Order> orderHelper(Iterable<Item> items,
    Iterable<Specification> specifications, Iterable<Order> orders) {
  if (specifications.isEmpty) {
    return orders;
  }

  return [];
}
