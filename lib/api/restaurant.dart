import "dart:convert";
import "dart:io";
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import "package:order_admin/api/utils.dart";
import "package:order_admin/models/bill.dart";
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

Future<void> updatePrinter(
    String restaurant, String name, String sn, String type) async {
  final token = await getToken();
  final response = await http.put(
      Uri.parse("$baseUrl/restaurants/$restaurant/printers"),
      body:
          jsonEncode({'name': name, 'sn': sn, 'type': type, 'description': ''}),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 204) {
  } else {
    throw Exception('Failed to update printer');
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

Future<Table> createTable(
    String restaurantId, String label, int x, int y) async {
  final token = await getToken();
  final response = await http.post(
      Uri.parse("$baseUrl/restaurants/$restaurantId/tables"),
      body: jsonEncode({'label': label, 'x': x, 'y': y}),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 201) {
    return Table.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<Table> updateTable(String tableId, String label, int x, int y) async {
  final token = await getToken();
  final response = await http.put(Uri.parse("$baseUrl/tables/$tableId"),
      body: jsonEncode({'label': label, 'x': x, 'y': y}),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode == 200) {
    return Table.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update restaurant');
  }
}

Future<void> deleteTable(String id) async {
  final token = await getToken();
  final response = await http.delete(Uri.parse("$baseUrl/tables/$id"),
      headers: {'Authorization': "bearer $token"});
  if (response.statusCode != 204) {
    throw Exception('Failed to delete table');
  }
}

Future<Item> createItem(String restaurantId, PutItem item) async {
  final token = await getToken();
  final response = await http.post(
      Uri.parse("$baseUrl/restaurants/$restaurantId/items"),
      body: jsonEncode(item),
      headers: {
        'Authorization': "bearer $token",
      });
  if (response.statusCode == 201) {
    return Item.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

Future<Item> updateItem(String itemId, PutItem item) async {
  final token = await getToken();
  final response = await http.put(Uri.parse("$baseUrl/items/$itemId"),
      body: jsonEncode(item),
      headers: {
        'Authorization': "bearer $token",
      });
  if (response.statusCode == 201) {
    return Item.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update item');
  }
}

Future<void> deleteItem(String id) async {
  final token = await getToken();
  final response = await http.delete(Uri.parse("$baseUrl/items/$id"), headers: {
    'Authorization': "bearer $token",
  });
  if (response.statusCode != 204) {
    throw Exception('Failed to delete item');
  }
}

Future<UploadImage> uploadItemImage(String itemId, File file) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse("$baseUrl/items/$itemId/image"),
  );
  final token = await getToken();
  Map<String, String> headers = {
    "Content-type": "multipart/form-data",
    'Authorization': "bearer $token"
  };
  request.files.add(
    http.MultipartFile(
      'file',
      file.readAsBytes().asStream(),
      file.lengthSync(),
      filename: file.path.split('/').last,
    ),
  );
  request.headers.addAll(headers);
  var res = await request.send();
  http.Response response = await http.Response.fromStream(res);
  if (res.statusCode == 201) {
    return UploadImage.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create restaurant');
  }
}

// todo: type
class ApiClient {
  static var dio = Dio();

  static Future<String> uploadFile(
      String itemId, List<int> file, String fileName) async {
    final token = await getToken();
    dio.options.headers['content-Type'] = "multipart/form-data";
    dio.options.headers["authorization"] = "bearer $token";

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file,
        filename: fileName,
        contentType: MediaType("image", "png"),
      )
    });
    Response response = await dio.post(
        "https://ordering-api-uat.sum-foods.com/items/$itemId/image",
        // "$baseUrl/items/$itemId/images", // todo
        data: formData);
    if (response.statusCode == 201) {
      return response.data['url'];
      // return UploadImage.fromJson(jsonDecode(response.body));
      // return;
    } else {
      throw Exception('Failed to create restaurant');
    }
  }
}

Future<Bill> createBill(
    String tableId, List<Specification> specifications) async {
  final createBillRequest = CreateBillRequest(specifications: specifications);
  final response = await http.post(
    Uri.parse("$baseUrl/tables/$tableId/orders"),
    body: jsonEncode(createBillRequest),
  );
  if (response.statusCode == 201) {
    return Bill.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create bill');
  }
}
