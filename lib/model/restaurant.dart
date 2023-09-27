import 'package:order_admin/model/model.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
      id: json["id"], name: json["name"], description: json["description"]);
}

class RestaurantList {
  final Pagination pagination;
  final List<Restaurant> data;
  const RestaurantList({
    required this.pagination,
    required this.data,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) => RestaurantList(
      data: convert(json["data"]),
      pagination: Pagination.fromJson(json["pagination"]));
}

List<Restaurant> convert(List<Map<String, dynamic>> array) =>
    array.map((a) => Restaurant.fromJson(a)).toList();
