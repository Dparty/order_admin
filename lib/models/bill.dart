import 'package:order_admin/models/order.dart';

class Bill {
  final String id;
  final String status;
  final Iterable<Order> orders;
  const Bill({required this.id, required this.status, required this.orders});
  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
        id: json['id'],
        status: json['status'],
        orders: (json['orders'] as Iterable).map((e) => Order.fromJson(e)));
  }
}
