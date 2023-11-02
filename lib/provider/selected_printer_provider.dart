import 'package:flutter/material.dart';
import 'package:order_admin/models/restaurant.dart' as model;
import 'package:order_admin/models/bill.dart';

class SelectedPrinterProvider with ChangeNotifier {
  model.Printer? _selectedPrinter;

  model.Printer? get selectedPrinter => _selectedPrinter;

  void setPrinter(model.Printer printer) {
    _selectedPrinter = printer;
    notifyListeners();
  }

  void resetSelectPrinter() {
    _selectedPrinter = null;
    notifyListeners();
  }
}
