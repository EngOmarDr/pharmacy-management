class Company {
  final int id;
  final String name;
  final String phone;

  Company({required this.id, required this.name, required this.phone});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['id'],
        name: json['name'],
        phone: json['phone_number'].toString(),
      );

}
