import 'package:order_admin/models/model.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
      id: json["id"], name: json["name"], description: json["description"]);
}

class RestaurantList {
  final Pagination pagination;
  final List<Restaurant> data;
  const RestaurantList({
    required this.pagination,
    required this.data,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    Iterable restaurantList = json["data"];
    return RestaurantList(
        data: List<Restaurant>.from(restaurantList
            .map((restaurant) => Restaurant.fromJson(restaurant))),
        pagination: Pagination.fromJson(json["pagination"]));
  }
}

class Option {
  final String label;
  final int extra;

  Option({required this.label, required this.extra});
  factory Option.fromJson(Map<String, dynamic> json) =>
      Option(label: json['label'], extra: json['extra']);
}

class Attribute {
  final String label;
  final List<Option> options;

  Attribute({required this.label, required this.options});

  factory Attribute.fromJson(Map<String, dynamic> json) {
    Iterable options = json['options'];
    return Attribute(
        label: json['label'],
        options: List<Option>.from(options.map((o) => Option.fromJson(o))));
  }
}

class Item {
  final String id;
  final String name;
  final int pricing;
  final List<Attribute> attributes;
  Item(
      {required this.id,
      required this.name,
      required this.pricing,
      required this.attributes});

  factory Item.fromJson(Map<String, dynamic> json) {
    Iterable attributes = json['attributes'];
    return Item(
        attributes:
            List<Attribute>.from(attributes.map((a) => Attribute.fromJson(a))),
        id: json['id'],
        name: json['name'],
        pricing: json['pricing']);
  }
}

class ItemList {
  final List<Item> data;
  final Pagination pagination;

  ItemList({required this.data, required this.pagination});
  factory ItemList.fromJson(Map<String, dynamic> json) {
    Iterable items = json['data'];
    return ItemList(
        data: List<Item>.from(items.map((i) => Item.fromJson(i))),
        pagination: Pagination.fromJson(json['pagination']));
  }
}

class PrinterList {
  final List<Printer> data;
  final Pagination pagination;

  PrinterList({required this.data, required this.pagination});
  factory PrinterList.fromJson(Map<String, dynamic> json) {
    Iterable printers = json['data'];
    return PrinterList(
        pagination: Pagination.fromJson(json['pagination']),
        data: List<Printer>.from(
            printers.map((printer) => Printer.fromJson(printer))));
  }
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
  factory Printer.fromJson(Map<String, dynamic> json) {
    return Printer(
        sn: json['sn'],
        id: json['id'],
        name: json['name'],
        description: json['description'],
        type: json['type']);
  }
}
