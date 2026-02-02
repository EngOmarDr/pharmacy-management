class Medicine {
  final int id;
  final int company;
  final String brandName;
  final String barcode;
  final int salePrice;
  final int purchasePrice;
  final bool needPrescription;
  final int minQuantity;
  final String type;

  Medicine({
    required this.id,
    required this.brandName,
    required this.barcode,
    required this.company,
    required this.salePrice,
    required this.purchasePrice,
    required this.needPrescription,
    required this.minQuantity,
    required this.type,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
      id: json['id'],
      brandName: json['brand_name'],
      barcode: json['barcode'],
      type: json['type'],
      company: json['company'],
      minQuantity: json['min_quantity'],
      needPrescription: json['need_prescription'],
      purchasePrice: json['purchase_price'],
      salePrice: json['sale_price']);
}
