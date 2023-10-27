import "dart:convert";
import 'package:http/http.dart' as http;
import "package:order_admin/api/utils.dart";
import '../models/session.dart';
import "config.dart";

Future<Session> signinApi(String email, String password) async {
  var body = jsonEncode({'email': email, 'password': password});
  final response = await http.post(Uri.parse("$baseUrl/sessions"),
      body: body, headers: {'Authorization': await getToken()});

  if (response.statusCode == 201) {
    return Session.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to Signin');
  }
}
