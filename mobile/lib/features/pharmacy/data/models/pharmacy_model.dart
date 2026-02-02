import 'package:pharmacy/features/pharmacy/domain/entities/pharmacy.dart';

class PharmacyModel extends Pharmacy {
  PharmacyModel(
      {required super.name,
      required super.city,
      required super.street,
      required super.phoneNumber,
      required super.region});

  factory PharmacyModel.formJson(Map<String, dynamic> json) {
    return PharmacyModel(
        name: json['name'],
        city: json['city'],
        street: json['street'],
        phoneNumber: json['phone_number'],
        region: json['region']);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'city': city,
        'street': street,
        'phone_number': phoneNumber,
        'region': region,
      };
}
