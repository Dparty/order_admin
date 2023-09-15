class Account {
  final String email;
  final String id;
  const Account({
    required this.email,
    required this.id,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      Account(id: json["id"], email: json["email"]);
}
