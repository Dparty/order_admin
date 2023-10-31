import 'dart:developer';

import 'package:flutter/material.dart';
import '../restaurant-settings/Seat.dart';
import 'package:order_admin/models/restaurant.dart' as model;

class SelectionButtonProvider with ChangeNotifier {
  final List<Seat> _selectedSeats = [];

  List<Seat> get selectedSeats => _selectedSeats;

  void addSeat(Seat seat) {
    _selectedSeats.add(seat);
    log("${seat.seatLabel} added");
    notifyListeners();
  }

  void removeSeat(Seat seat) {
    _selectedSeats.remove(seat);
    log("${seat.seatLabel} removed");
    notifyListeners();
  }

  bool isSeatSelected(Seat seat) {
    return _selectedSeats.contains(seat);
  }
}
