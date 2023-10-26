import 'dart:developer';

import 'package:flutter/material.dart';
import '../restaurant-settings/Seat.dart';
import 'package:order_admin/models/restaurant.dart' as model;

class SelectedTableProvider with ChangeNotifier {
  model.Table? _selectedTable;

  model.Table? get selectedTable => _selectedTable;

  void selectTable(model.Table table) {
    _selectedTable = table;
    notifyListeners();
  }

  void resetSelectTable() {
    _selectedTable = null;
    notifyListeners();
  }
}
