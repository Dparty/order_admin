import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/cart_item.dart';
import 'package:collection/collection.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => cart.map((e) => e.quantity).sum;
  int get quantity => cart.map((e) => e.quantity).sum;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  Map<String, List<CartItem>> cartMap = {};
  List<CartItem> cart = [];

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

  void addCounter() {
    _counter++;
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    notifyListeners();
  }

  int getCounter() {
    return _counter;
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
    // var cartList = [];
    // for (int i = 0; i < cart.length; i++) {
    //   CartListForBillItem item =
    //       CartListForBillItem(ItemId: cart[i].id, Options: cart[i].attributes);
    //   cartList.add(item);
    // }
    // return cartList;
  }

  int get total {
    return cart.map((e) => e.total).sum;
  }

  void resetShoppingCart() {
    cart = [];
  }
}
