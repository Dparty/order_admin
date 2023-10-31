import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/bill.dart';

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
    _tableOrders = orders;
    notifyListeners();
  }

  void resetSelectTable() {
    _selectedTable = null;
    _tableOrders = [];
    notifyListeners();
  }
}
