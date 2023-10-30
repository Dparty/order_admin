import 'dart:developer';

import 'package:flutter/material.dart';
import '../restaurant-settings/Seat.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/bill.dart';

import 'package:order_admin/api/restaurant.dart';

class SelectedTableProvider with ChangeNotifier {
  model.Table? _selectedTable;
  List<Bill>? _tableOrders;

  model.Table? get selectedTable => _selectedTable;
  List<Bill>? get tableOrders => _tableOrders;

  void selectTable(model.Table table) {
    _selectedTable = table;

    notifyListeners();
  }

  void setTableOrders(List<Bill>? orders) {
    print(orders?.length);
    _tableOrders = orders;
    notifyListeners();
  }

  void resetSelectTable() {
    _selectedTable = null;
    notifyListeners();
  }
}
