import 'package:order_admin/models/order.dart';

class Bill {
  final String id;
  final String status;
  final int pickUpCode;
  final List<Order> orders;
  final String? TableLabel;
  const Bill(
      {required this.id,
      required this.status,
      required this.orders,
      required this.pickUpCode,
      this.TableLabel});
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
        id: json['id'],
        status: json['status'],
        pickUpCode: json['pickUpCode'],
        TableLabel: json['TableLabel'],
        orders: (json['orders'] as Iterable)
            .map((e) => Order.fromJson(e))
            .toList());
  }
}
