import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/bill.dart';
import 'package:collection/collection.dart';

Function deepEq = const DeepCollectionEquality.unordered().equals;
Function eq = const ListEquality().equals;

class SelectedTableProvider with ChangeNotifier {
  model.Table? _selectedTable;
  List<Bill>? _tableOrders;
  List<String>? _selectedBillIds;

  model.Table? get selectedTable => _selectedTable;
  List<Bill>? get tableOrders => _tableOrders;
  List<String>? get selectedBillIds => _selectedBillIds;

  bool equal(List<Bill>? target, List<Bill>? prev) {
    if (target!.isEmpty || prev!.isEmpty) return false;
    if (target?.length != target?.length) return false;
    final idList = {...target!.map((e) => e.tableLabel).toList()}.toList();
    final preIdList = {...prev!.map((e) => e.tableLabel).toList()}.toList();
    return eq(idList, preIdList);
  }

  void selectTable(model.Table table) {
    _selectedTable = table;
    notifyListeners();
  }

  void setAllTableOrders(List<Bill>? orders) {
    _tableOrders = orders;
    notifyListeners();
  }

  void setSelectedBillIds(List<String>? ids) {
    _selectedBillIds = ids;
    notifyListeners();
  }

  void removeId(String id) {
    _selectedBillIds?.remove(id);
  }

  void addId(String id) {
    _selectedBillIds?.add(id);
  }

  void resetSelectTable() {
    _selectedTable = null;
    _tableOrders = [];
    notifyListeners();
  }
}
