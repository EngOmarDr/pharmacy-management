class Login {
  final String type;
  final int? pharmacyId;
  final Tokens tokens;

  Login({required this.type, required this.pharmacyId, required this.tokens});

}

class Tokens {
  String refresh;
  String access;

  Tokens({required this.refresh, required this.access});
}
