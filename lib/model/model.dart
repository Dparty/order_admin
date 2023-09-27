abstract class Model {
  fromJson(Map<String, dynamic> json) => Model;
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

class PaginationList<T> {
  final Pagination pagination;
  final T data;
  const PaginationList({
    required this.pagination,
    required this.data,
  });
}
