
class MedicineModel {
  final String brandName;
  final String barcode;
  final int company;
  final int salePrice;
  final int purchasePrice;
  final bool needPrescription ;
  final int minQuantity;
  final String type;


  MedicineModel({
    required this.brandName,
    required this.barcode,
    required this.salePrice,
    required this.company,
    required this.purchasePrice,
    required this.needPrescription,
    required this.minQuantity,
    required this.type,
  });

  Map<String, String> toJson() => {
        'brand_name': brandName,
        'barcode': barcode,
        'sale_price': '$salePrice',
        'company': '$company',
        'purchase_price': '$purchasePrice',
        'need_prescription': '$needPrescription',
        'min_quantity': '$minQuantity',
        'type': type
      };
}
