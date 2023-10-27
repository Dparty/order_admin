import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/cart_item.dart';
import 'package:collection/collection.dart';

class CartProvider with ChangeNotifier {
  int get quantity => cart.map((e) => e.quantity).sum;
  Map<String, List<CartItem>> cartMap = {};
  List<CartItem> cart = [];
  int get total {
    return cart.map((e) => e.total).sum;
  }

  void addToCart(CartItem item) {
    for (final c in cart) {
      if (c.equal(item)) {
        c.quantity++;
        notifyListeners();
        return;
      }
    }
    cart.add(item);
    notifyListeners();
  }

  void addQuantity(CartItem item) {
    addToCart(item);
    notifyListeners();
  }

  void deleteQuantity(CartItem item) {
    cart = cart.where((i) => !i.equal(item)).toList();
    notifyListeners();
  }

  void removeItem(CartItem item) {
    for (var i = 0; i < cart.length; i++) {
      if (cart[i].equal(item)) {
        cart[i].quantity--;
      }
    }
    cart = cart.where((i) => i.quantity > 0).toList();
    notifyListeners();
  }

  getCartListForBill() {
    // TODO: selectedItems List<Map<String, String>>?

    var cartList = [];
    for (var i = 0; i < cart.length; i++) {
      for (var j = 0; j < cart[i].quantity; j++) {
        CartListForBillItem item = CartListForBillItem(
            ItemId: cart[i].id, Options: [cart[i].selectedItems]);
        cartList.add(item);
      }
    }
    return cartList;
  }

  void resetShoppingCart() {
    cart = [];
  }
}
