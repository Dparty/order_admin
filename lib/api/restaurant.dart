import "dart:convert";
import 'package:http/http.dart' as http;
import "package:order_admin/api/utils.dart";
import 'package:order_admin/models/restaurant.dart';
import "config.dart";

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
  var body = jsonEncode({'name': name, 'description': description});
  final response = await http.post(
    Uri.parse("$baseUrl/restaurants"),
    body: body,
    headers: {'Authorization': "bearer $token"},
  );
  if (response.statusCode == 201) {
    return Restaurant.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}
