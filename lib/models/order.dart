import 'package:order_admin/models/model.dart';
import 'package:order_admin/models/restaurant.dart';

class Order {
  final Item item;
  final Iterable<Pair> options;
  const Order({
    required this.item,
    required this.options,
  });
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        item: Item.fromJson(json['item']),
        options:
            (json['specification'] as Iterable).map((e) => Pair.fromJson(e)));
  }
}
