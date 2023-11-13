import "package:shared_preferences/shared_preferences.dart";
import './config.dart';

const qrcodeApi =
    'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=';
const orderWebDomain = 'https://ordering-uat.sum-foods.com';

String createQrcodeUrl(String text) {
  return "$qrcodeApi$text";
}

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

String createOrderingUrl(String restaurantId, String tableId) {
  return "$orderingBaseUrl/ordering/?restaurantId=$restaurantId&tableId=$tableId";
  // return createQrcodeUrl(Uri.encodeComponent(
  //     "$orderingBaseUrl/ordering/?restaurantId=$restaurantId&tableId=$tableId"));
}

String createOrderingUrlRemote(String restaurantId, String tableId) {
  return createQrcodeUrl(Uri.encodeComponent(
      "$orderingBaseUrl/ordering/?restaurantId=$restaurantId&tableId=$tableId"));
}
