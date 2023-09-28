import "dart:convert";
import 'package:http/http.dart' as http;
import "package:order_admin/api/utils.dart";
import 'package:order_admin/models/restaurant.dart';
import "config.dart";

Future<Restaurant> getRestaurant(String id) async {
  final response = await http.get(Uri.parse("$baseUrl/restaurants/$id"));
  if (response.statusCode == 200) {
    return Restaurant.fromJson(jsonDecode(response.body));
  } else {
    switch (response.statusCode) {
      case 404:
        throw Exception('404 Not Found');
    }
    throw Exception('Unknown error');
  }
}

Future<RestaurantList> listRestaurant() async {
  final token = await getToken();
  final response = await http.get(Uri.parse("$baseUrl/restaurants"),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 200) {
    return RestaurantList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<Restaurant> createRestaurant(String name, String description) async {
  final token = await getToken();
  final response = await http.post(
    Uri.parse("$baseUrl/restaurants"),
    body: jsonEncode({'name': name, 'description': description}),
    headers: {'Authorization': "bearer $token"},
  );
  if (response.statusCode == 201) {
    return Restaurant.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<ItemList> listItem(String restaurantId) async {
  final response = await http.get(
    Uri.parse("$baseUrl/restaurants/$restaurantId/items"),
  );
  if (response.statusCode == 200) {
    return ItemList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<PrinterList> listPrinters(String restaurantId) async {
  final token = await getToken();
  final response = await http.get(
      Uri.parse("$baseUrl/restaurants/$restaurantId/printers"),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 200) {
    return PrinterList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<Printer> createPrinter(
    String restaurant, String name, String sn, String type) async {
  final token = await getToken();
  final response = await http.post(
      Uri.parse("$baseUrl/restaurants/$restaurant/printers"),
      body:
          jsonEncode({'name': name, 'sn': sn, 'type': type, 'description': ''}),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 201) {
    return Printer.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<void> deletePrinter(String id) async {
  final token = await getToken();
  final response = await http.delete(Uri.parse("$baseUrl/printers/$id"),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode != 204) {
    throw Exception('Failed to create restaurant');
  }
}

Future<Table> createTable(String restaurantId, String label) async {
  final token = await getToken();
  final response = await http.post(
      Uri.parse("$baseUrl/restaurants/$restaurantId/tables"),
      body: jsonEncode({'label': label}),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 201) {
    return Table.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<List<Table>> listTable(String restaurantId) async {
  final response =
      await http.get(Uri.parse("$baseUrl/restaurants/$restaurantId/tables"));
  if (response.statusCode == 200) {
    return TableList.fromJson(jsonDecode(response.body)).data;
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<void> deleteTable(String id) async {
  final token = await getToken();
  final response = await http.delete(Uri.parse("$baseUrl/tables/$id"),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode != 204) {
    throw Exception('Failed to create restaurant');
  }
}
