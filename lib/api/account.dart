import "dart:convert";
import 'package:http/http.dart' as http;
import "../model/Session.dart";
import "config.dart";

Future<Session> signinApi(String email, String password) async {
  final response = await http.post(Uri.parse("$baseUrl/account/session"));

  if (response.statusCode == 201) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Session.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to Signin');
  }
}
