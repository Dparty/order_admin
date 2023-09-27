import "package:shared_preferences/shared_preferences.dart";

Future<String> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");
  if (token != null) {
    return token;
  }
  return "";
}

Future signout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("token");
}
