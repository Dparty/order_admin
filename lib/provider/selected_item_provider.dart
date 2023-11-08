import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;

class SelectedItemProvider with ChangeNotifier {
  model.Item? _selectedItem;

  model.Item? get selectedItem => _selectedItem;

  void setItem(model.Item item) {
    _selectedItem = item;
    notifyListeners();
  }

  void resetSelectItem() {
    _selectedItem = null;
    notifyListeners();
  }
}
