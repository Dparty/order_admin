import 'package:order_admin/models/model.dart';

enum Status { ACTIVED, DEACTIVED }

enum PageType { SETTING, CONFIG }

class Restaurant {
  final String id;
  final String name;
  final String description;
  final List<Item> items;

  final List<Printer>? printers;
  final List<Table> tables;
  final List<String> categories;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
    this.printers,
    required this.tables,
    required this.categories,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        items:
            (json['items'] as Iterable).map((i) => Item.fromJson(i)).toList(),
        tables:
            (json['tables'] as Iterable).map((i) => Table.fromJson(i)).toList(),
        categories:
            (json['categories'] as Iterable).map((a) => a as String).toList(),
      );
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
  final List<String> printers;
  final List images;
  final String status;

  Item({
    required this.id,
    required this.name,
    required this.pricing,
    required this.tags,
    required this.attributes,
    required this.images,
    required this.printers,
    required this.status,
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
      status: json['status'],
      printers: (json['printers'] as Iterable).map((a) => a as String).toList(),
    );
  }
}

class PutItem {
  final String name;
  final int pricing;
  final List<String> tags;
  final List<String> printers;
  final List<Attribute> attributes;
  final String status;
  final List images;

  PutItem({
    required this.printers,
    required this.tags,
    required this.name,
    required this.pricing,
    required this.status,
    required this.images,
    required this.attributes,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pricing': pricing,
      'tags': tags,
      'printers': printers,
      'attributes': attributes,
      'status': status,
      'images': images,
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
  final String model;

  Printer({
    required this.id,
    required this.sn,
    required this.name,
    required this.description,
    required this.type,
    required this.model,
  });
  factory Printer.fromJson(Map<String, dynamic> json) => Printer(
        sn: json['sn'],
        id: json['id'],
        name: json['name'],
        description: json['description'],
        type: json['type'],
        model: json['model'],
      );
}

class Table {
  final String id;
  final String label;
  final int? x;
  final int? y;

  Table({required this.id, required this.label, this.x, this.y});

  factory Table.fromJson(Map<String, dynamic> json) =>
      Table(id: json['id'], label: json['label'], x: json['x'], y: json['y']);
}

class CreateBillRequest {
  final List<Specification> specifications;
  const CreateBillRequest({required this.specifications});
  Map<String, dynamic> toJson() {
    return {'specifications': specifications};
  }

  factory CreateBillRequest.fromJson(Map<String, dynamic> json) =>
      CreateBillRequest(specifications: json['specifications']);
}

class Specification {
  final String itemId;
  final List<Pair> options;
  Specification({required this.itemId, required this.options});

  Map<String, dynamic> toJson() {
    return {'itemId': itemId, 'options': options};
  }

  factory Specification.fromJson(Map<String, dynamic> json) =>
      Specification(itemId: json['itemId'], options: []);
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
