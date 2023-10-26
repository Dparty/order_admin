import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart';
import 'model.dart';

class CartItem {
  late final String? id;
  final String? productId;
  final String? productName;
  final double? initialPrice;
  final double? productPrice;
  final ValueNotifier<int>? quantity;
  final String? unitTag;
  final String? image;
  List? attributes = [];

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image,
    this.attributes,
  });
}

class CartListForBillItem {
  late final String? ItemId;
  List? Options = [];

  CartListForBillItem({
    required this.ItemId,
    this.Options,
  });

  CartListForBillItem.fromJson(Map<String, dynamic> json)
      : ItemId = json['ItemId'],
        Options = json['Options'];

  Map<String, dynamic> toJson() {
    return {
      'ItemId': ItemId,
      'Options': Options,
    };
  }
}
