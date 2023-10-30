import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';
import 'model.dart';

class CartItem {
  String get id => item.id;
  final Item item;
  String get productId => item.id;
  String get productName => item.name;
  final Map<String, String> selectedItems;
  final double? initialPrice;
  final double? productPrice;
  int quantity;
  final String? unitTag;
  String get image {
    if (item.images.isEmpty) {
      return "";
    }
    return item.images[0];
  }

  int get price {
    var total = 0;
    for (final attribute in item.attributes) {
      for (final option in attribute.options) {
        if (selectedItems[attribute.label] == option.label) {
          total += option.extra;
        }
      }
    }
    return item.pricing + total;
  }

  bool equal(CartItem target) {
    if (id != target.id) return false;
    if (selectedItems.length != target.selectedItems.length) return false;
    for (var k in selectedItems.keys) {
      if (selectedItems[k] != target.selectedItems[k]) return false;
    }
    return true;
  }

  int get total {
    return price * quantity;
  }

  Iterable<Specification> toSpecification() {
    Iterable<Pair> pairs = [];
    selectedItems.forEach((key, value) {
      pairs.toList().add(Pair(left: key, right: value));
    });
    return List<int>.generate(quantity, (i) => i)
        .map((e) => Specification(itemId: id, options: pairs));
  }

  CartItem({
    required this.item,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.selectedItems,
  });
}

class CartListForBillItem {
  late final String? itemId;
  List<Pair>? options = [];

  CartListForBillItem({
    required this.itemId,
    this.options,
  });

  CartListForBillItem.fromJson(Map<String, dynamic> json)
      : itemId = json['itemId'],
        options = json['options'];

  Map<String, dynamic> toJson() {
    return {
      'ItemId': itemId,
      'Options': options,
    };
  }
}
