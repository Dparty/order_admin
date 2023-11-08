class Session {
  final String token;

  const Session({
    required this.token,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(token: json["token"]);
  }
}
