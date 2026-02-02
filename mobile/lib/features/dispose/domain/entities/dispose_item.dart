class DisposeItem {
  final String id;
  final String medicine;
  final String quantity;
  final String price;
  final String expiryDate;

  DisposeItem(
      {required this.id,
      required this.medicine,
      required this.quantity,
      required this.price,
      required this.expiryDate});

  factory DisposeItem.fromJson(Map<String, dynamic> json) {
    return DisposeItem(
        id: json['id'],
        medicine: json['medicine'],
        quantity: json['quantity'],
        price: json['price'],
        expiryDate: json['expiry_date']);
  }
}
