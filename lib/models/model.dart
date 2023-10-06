abstract class Model {
  fromJson(Map<String, dynamic> json) => Model;
}

class Pair {
  final String left;
  final String right;
  Pair(this.left, this.right);
  factory Pair.fromJson(Map<String, dynamic> json) =>
      Pair(json['left'], json['right']);
}

class Pagination {
  final int index;
  final int limit;
  final int total;
  const Pagination({
    required this.index,
    required this.limit,
    required this.total,
  });
  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
      index: json["index"], limit: json["limit"], total: json["total"]);
}
