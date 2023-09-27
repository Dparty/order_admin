import "dart:convert";
import 'package:http/http.dart' as http;
import "package:order_admin/api/utils.dart";
import "package:order_admin/model/restaurant.dart";
import "config.dart";

Future<RestaurantList> listRestaurant() async {
  final token = await getToken();
  final response = await http.get(Uri.parse("$baseUrl/restaurants"),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 200) {
    return RestaurantList.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Signin');
  }
}
