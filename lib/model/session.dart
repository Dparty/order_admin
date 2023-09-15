import "account.dart";

class Session {
  final Account account;
  final String token;

  const Session({
    required this.account,
    required this.token,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
        account: Account.fromJson(json["account"]), token: json["token"]);
  }
}
