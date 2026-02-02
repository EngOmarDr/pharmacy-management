class MedicineList {
  final int id;
  final String brandName;
  final String barcode;
  final String type;
  final int price;
  final int quantity;
  final bool isExpired;
  final String companyName;
  final bool isNeedPrescription;
  // final bool? isActive;

  MedicineList({
    required this.id,
    required this.brandName,
    required this.barcode,
    required this.type,
    required this.price,
    required this.quantity,
    required this.isExpired,
    required this.companyName,
    required this.isNeedPrescription,
    // this.isActive,
  });

  factory MedicineList.fromJson(Map<String, dynamic> json) {
    return MedicineList(
      id: json['id'],
      brandName: json['brand_name'],
      barcode: json['barcode'],
      type: json['type'],
      price: json['price'],
      quantity: json['quantity'],
      isExpired: json['is_expired'],
      companyName: json['company'],
      isNeedPrescription: json['need_prescription'],
      // isActive: json['is_active'],
    );
  }

}
