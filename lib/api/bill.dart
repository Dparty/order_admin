import "dart:convert";
import 'package:http/http.dart' as http;
import "package:order_admin/api/utils.dart";
import "package:order_admin/models/bill.dart";
import "config.dart";

Future<List<Bill>> listBills(String restaurantId, String? status,
    String? tableId, int startAt, int endAt) async {
  final query = {
    'restaurantId': restaurantId,
    'status': status,
    'tableId': tableId,
    'startAt': startAt,
    'endAt': endAt,
  };
  final response = await http.get(
      Uri.https(restaurantApiDomain, "/bills", query),
      headers: {'Authorization': await getToken()});
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as Iterable)
        .map((e) => Bill.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to getBill');
  }
}
