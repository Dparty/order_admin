import 'package:order_admin/models/model.dart';

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

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    Iterable restaurantList = json["data"];
    return RestaurantList(
        data: List<Restaurant>.from(restaurantList
            .map((restaurant) => Restaurant.fromJson(restaurant))),
        pagination: Pagination.fromJson(json["pagination"]));
  }
}
