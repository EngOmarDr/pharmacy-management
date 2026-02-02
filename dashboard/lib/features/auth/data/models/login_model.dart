import '../../domain/enities/login.dart';

class LoginModel extends Login {
  LoginModel(
      {required super.type, required super.pharmacyId, required super.tokens});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      type: json['type'],
      pharmacyId: json['pharmacy_id'],
      tokens: TokensModel.formJson(json['tokens']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'pharmacy_id': pharmacyId,
      'tokens':
          TokensModel(access: tokens.access, refresh: tokens.refresh).toJson(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  LoginModel copyWith({String? type ,int? pharmacyId,TokensModel? tokens}) {
    return LoginModel(type: type??this.type, pharmacyId: pharmacyId??this.pharmacyId, tokens: tokens??this.tokens);
  }
}

class TokensModel extends Tokens {
  TokensModel({required super.refresh, required super.access});

  factory TokensModel.formJson(Map<String, dynamic> json) {
    return TokensModel(access: json['access'], refresh: json['refresh']);
  }

  Map<String, dynamic> toJson() {
    return {'access': access, 'refresh': refresh};
  }
}
