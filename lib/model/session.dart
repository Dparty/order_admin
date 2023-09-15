import "account.dart";

class Session {
  final Account account;
  final String token;

  const Session({
    required this.account,
    required this.token,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(account: json["account"], token: json["token"]);
  }
}
