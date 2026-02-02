import 'package:dashboard/features/pharmacy/domain/entities/pharmacy.dart';

class PharmacyModel extends Pharmacy {
  PharmacyModel({
    required super.id,
    required super.name,
    required super.city,
    required super.street,
    required super.phoneNumber,
    required super.region,
  });

  PharmacyModel.withoutId({
    super.id = 0,
    required super.name,
    required super.city,
    required super.street,
    required super.phoneNumber,
    required super.region,
  });

  factory PharmacyModel.formJson(Map<String, dynamic> json) {
    return PharmacyModel(
        id: json['id'],
        name: json['name'],
        city: json['city'],
        street: json['street'],
        phoneNumber: int.parse(json['phone_number']),
        region: json['region']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'street': street,
        'phone_number': phoneNumber,
        'region': region,
      };
}
