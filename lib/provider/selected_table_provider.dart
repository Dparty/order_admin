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

  void resetSelectTable(model.Table table) {
    _selectedTable = null;
    notifyListeners();
  }

  // void removeSeat(Seat seat) {
  //   _selectedSeats.remove(seat);
  //   log("${seat.seatLabel} removed");
  //   notifyListeners();
  // }
  //
  // bool isSeatSelected(Seat seat) {
  //   return _selectedSeats.contains(seat);
  // }
}
