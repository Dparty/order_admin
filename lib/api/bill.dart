import "dart:convert";
import 'package:http/http.dart' as http;
import "package:order_admin/api/utils.dart";
import "package:order_admin/models/bill.dart";
import "config.dart";

Future<List<Bill>> listBills(String restaurantId,
    {String? status, String? tableId, int? startAt, int? endAt}) async {
  final token = await getToken();
  final query = {
    'restaurantId': restaurantId,
    'status': status,
    'tableId': tableId,
    'startAt': startAt,
    'endAt': endAt,
  };
  final response = await http.get(
      Uri.https(restaurantApiDomain, "/bills", query),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as Iterable)
        .map((e) => Bill.fromJson(e))
        .toList();
  } else {
    throw Exception('Failed to getBill');
  }
}

Future<void> printBills(List<String> billIdList, int offset) async {
  final token = await getToken();
  final response = await http.post(
    Uri.parse("$baseUrl/bills/print"),
    body: jsonEncode({'billIdList': billIdList, 'offset': offset}),
    headers: {'Authorization': "bearer $token"},
  );
  if (response.statusCode == 200) {
    return;
  } else {
    throw Exception('Failed to printBills');
  }
}

Future<void> setBills(
    List<String> billIdList, int offset, String status) async {
  final token = await getToken();
  final response = await http.post(
    Uri.parse("$baseUrl/bills/set"),
    body: jsonEncode(
        {'billIdList': billIdList, 'offset': offset, 'status': status}),
    headers: {'Authorization': "bearer $token"},
  );
  if (response.statusCode == 200) {
    return;
  } else {
    throw Exception('Failed to setBills');
  }
}
