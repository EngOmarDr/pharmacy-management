// import 'package:hive/hive.dart';
//
// part 'medicine.g.dart';
//
// class Medicine {
//   final String brandName;
//   final String barcode;
//   final String type;
//   final int price;
//   final int quantity;
//   final String expiryDate;
//   final String? companyName;
//   final bool? isNeedPrescription;
//   final bool? isActive;
//
//   Medicine({
//     required this.brandName,
//     required this.barcode,
//     required this.type,
//     required this.price,
//     required this.quantity,
//     required this.expiryDate,
//     this.companyName,
//     this.isNeedPrescription,
//     this.isActive,
//   });
//
//   factory Medicine.fromJson(Map<String, dynamic> json) {
//     return Medicine(
//       brandName: json['brand_name'],
//       barcode: json['barcode'],
//       type: json['type'],
//       price: json['price'],
//       quantity: json['quantity'],
//       expiryDate: json['expiry_date'],
//       companyName: json['company_name'],
//       isActive: json['is_active'],
//       isNeedPrescription: json['need_prescription'],
//     );
//   }
//
//   Map<String, dynamic> medicineToJson() {
//     return {
//       'brand_name': brandName,
//       'barcode': barcode,
//       'type': type,
//       'quantity': quantity.toString(),
//       'price': price.toString(),
//       'expiry_date': expiryDate,
//       'company_name': companyName ?? '',
//       'need_prescription': '$isNeedPrescription',
//       'is_active': '${isActive ?? true}'
//     };
//   }
// }
//
// enum MedicineType {
//   liquids('السوائل', 'Liquids', 'LIQ'),
//   topical('الموضعية', 'Topical', 'TOP'),
//   inhalers('المستنشقات', 'Inhalers', 'INH'),
//   suppositories('التحاميل', 'Suppositories', 'SUP'),
//   injections('الحقن', 'Injections', 'INJ'),
//   drops('القطرات', 'Drops', 'DRO'),
//   capsules('الكبسولات', 'Capsules', 'CAP'),
//   tablets('اقراص', 'Tablets', 'TAB');
//
//   final String nameAr;
//   final String nameEn;
//   final String value;
//
//   const MedicineType(this.nameAr, this.nameEn, this.value);
// }
//
// @HiveType(typeId: 0)
// class MedicineSearch extends HiveObject {
//   @HiveField(0)
//   final int id;
//   @HiveField(1)
//   final String brandName;
//   @HiveField(2)
//   final int price;
//   @HiveField(3)
//   final String barcode;
//   @HiveField(4)
//   final String type;
//   @HiveField(5)
//   final int quantity;
//   @HiveField(6)
//   final String expiryDate;
//   @HiveField(7)
//   final String? companyName;
//   @HiveField(8)
//   final bool? isNeedPrescription;
//   @HiveField(9)
//   final bool? isActive;
//
//   MedicineSearch({
//     required this.id,
//     required this.barcode,
//     required this.brandName,
//     required this.price,
//     required this.type,
//     required this.quantity,
//     required this.expiryDate,
//     this.companyName,
//     this.isNeedPrescription,
//     this.isActive,
//   });
//
//   factory MedicineSearch.fromJson(Map<String, dynamic> json) {
//     return MedicineSearch(
//       id: json['id'],
//       brandName: json['brand_name'],
//       barcode: json['barcode'],
//       type: json['type'],
//       price: json['price'],
//       quantity: json['quantity'],
//       expiryDate: json['expiry_date'],
//       companyName: json['company'],
//       isActive: json['is_active'],
//       isNeedPrescription: json['need_prescription'],
//     );
//   }
// }
