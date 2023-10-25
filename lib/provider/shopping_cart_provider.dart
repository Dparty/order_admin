import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/cart_item.dart';
import 'package:collection/collection.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  Map<String, List<CartItem>> cartMap = {};
  List<CartItem> cart = [];

  void addToCart(item) {
    CartItem cartItem = CartItem(
      id: item.id,
      productId: item.id,
      productName: item.name,
      initialPrice: item.pricing,
      productPrice: item.pricing,
      quantity: ValueNotifier(1),
      unitTag: '1',
      image: item.images[0],
    );

    // // todo: 合併 id 一樣而且選擇的 specification 一樣的
    // if (!cartMap.containsKey(item.id)) {
    //   cartMap[item.id] = [cartItem];
    // } else {
    //   if (cartMap[item.id]?[0].unitTag == item.unitTag) {
    //   } else {
    //     cartMap[item.id]!.add(cartItem);
    //   }
    // }

    CartItem? target = cart.firstWhereOrNull((i) => i.id == item.id);

    if (target == null) {
      print(cartItem.productName);
      cart.add(cartItem);
      addTotalPrice(cartItem.productPrice! / 100 ?? 0.0);
    } else {
      addQuantity(item.id);
    }

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

  void addQuantity(String id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    notifyListeners();
  }

  void deleteQuantity(String id) {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    notifyListeners();
  }

  void removeItem(String id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    notifyListeners();
  }

  int getQuantity(int quantity) {
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    notifyListeners();
  }

  double getTotalPrice() {
    return _totalPrice;
  }
}
