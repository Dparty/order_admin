import 'package:flutter/material.dart';

class CartItem {
  late final String? id;
  final String? productId;
  final String? productName;
  final double? initialPrice;
  final double? productPrice;
  final ValueNotifier<int>? quantity;
  final String? unitTag;
  final String? image;

  CartItem(
      {required this.id,
      required this.productId,
      required this.productName,
      required this.initialPrice,
      required this.productPrice,
      required this.quantity,
      required this.unitTag,
      required this.image});
}
