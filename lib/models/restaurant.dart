import 'package:order_admin/models/model.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final List<Item> items;

  final List<Printer>? printers;
  final List<Table> tables;

  const Restaurant(
      {required this.id,
      required this.name,
      required this.description,
      required this.items,
      this.printers,
      required this.tables});

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      items: (json['items'] as Iterable).map((i) => Item.fromJson(i)).toList(),
      tables:
          (json['tables'] as Iterable).map((i) => Table.fromJson(i)).toList());
}

class RestaurantList {
  final List<Restaurant> data;
  const RestaurantList({
    required this.data,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
        data: List<Restaurant>.from((json["data"] as Iterable)
            .map((restaurant) => Restaurant.fromJson(restaurant))),
      );
}

class Option {
  final String label;
  final int extra;

  Option({required this.label, required this.extra});

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'extra': extra,
    };
  }

  factory Option.fromJson(Map<String, dynamic> json) =>
      Option(label: json['label'], extra: json['extra']);
}

class Attribute {
  final String label;
  final List<Option> options;

  Attribute({required this.label, required this.options});

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'options': options,
    };
  }

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
      label: json['label'],
      options: (json['options'] as Iterable)
          .map((o) => Option.fromJson(o))
          .toList());
}

class Item {
  final String id;
  final String name;
  final int pricing;
  final List<String> tags;
  final List<Attribute> attributes;
  final List images;

  Item({
    required this.id,
    required this.name,
    required this.pricing,
    required this.tags,
    required this.attributes,
    required this.images,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      attributes: (json['attributes'] as Iterable)
          .map((a) => Attribute.fromJson(a))
          .toList(),
      id: json['id'],
      name: json['name'],
      tags: (json['tags'] as Iterable).map((a) => a as String).toList(),
      pricing: json['pricing'],
      images: json['images'],
    );
  }
}

class PutItem {
  final String name;
  final int pricing;
  final List<String> tags;
  final List<String> printers;
  final List<Attribute> attributes;
  PutItem(
      {required this.printers,
      required this.tags,
      required this.name,
      required this.pricing,
      required this.attributes});
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pricing': pricing,
      'tags': tags,
      'printers': printers,
      'attributes': attributes,
    };
  }
}

class ItemList {
  final List<Item> data;
  final Pagination pagination;

  ItemList({required this.data, required this.pagination});
  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
      data: List<Item>.from(
          (json['data'] as Iterable).map((i) => Item.fromJson(i))),
      pagination: Pagination.fromJson(json['pagination']));
}

// todo: List<dynamic> refactor
class PrinterList {
  final List<Printer> data;

  PrinterList({required this.data});
  factory PrinterList.fromJson(List<dynamic> json) => PrinterList(
      data: List<Printer>.from(
          (json as Iterable).map((printer) => Printer.fromJson(printer))));
}

class Printer {
  final String id;
  final String name;
  final String sn;
  final String description;
  final String type;

  Printer(
      {required this.id,
      required this.sn,
      required this.name,
      required this.description,
      required this.type});
  factory Printer.fromJson(Map<String, dynamic> json) => Printer(
      sn: json['sn'],
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type']);
}

class Table {
  final String id;
  final String label;
  int? x;
  int? y;

  Table({required this.id, required this.label, this.x, this.y});

  factory Table.fromJson(Map<String, dynamic> json) =>
      Table(id: json['id'], label: json['label'], x: json['x'], y: json['y']);
}

class Specification {
  final String itemId;
  final Iterable<Pair> options;
  Specification({required this.itemId, required this.options});

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'options': options,
    };
  }

  factory Specification.fromJson(Map<String, dynamic> json) => Specification(
      itemId: json['itemId'],
      options: (json['options'] as Iterable).map((o) => Pair.fromJson(o)));
}

class TableList {
  final List<Table> data;

  TableList({required this.data});
  factory TableList.fromJson(Map<String, dynamic> json) => TableList(
      data: List<Table>.from((json['data'] as Iterable)
          .map((printer) => Table.fromJson(printer))));
}

class UploadImage {
  final String url;

  UploadImage({required this.url});

  factory UploadImage.fromJson(Map<String, dynamic> json) =>
      UploadImage(url: json['url']);
}

// class OrderItem {
//   final String id;
//   final int pickUpCode;
//   final String status;
//   final List<Order> orders;
//
//   const OrderItem({
//     required this.id,
//     required this.pickUpCode,
//     required this.status,
//     required this.orders,
//   });
//
//   factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
//         id: json["id"],
//         pickUpCode: json["pickUpCode"],
//         status: json["status"],
//         orders:
//             (json['orders'] as Iterable).map((i) => Order.fromJson(i)).toList(),
//       );
// }
//
// class Order {
//   final Item item;
//   final List<Pair> specification;
//
//   Order({
//     required this.item,
//     required this.specification,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       item: Item.fromJson(json['item']),
//       specification: (json['specification'] as Iterable)
//           .map((i) => Pair.fromJson(i))
//           .toList(),
//     );
//   }
// }

// class OrderList {
//   final List<OrderItem> data;
//
//   OrderList({required this.data});
//   factory OrderList.fromJson(List<dynamic> json) => OrderList(
//       data: List<OrderItem>.from(json.map((i) => OrderItem.fromJson(i))));
// }
