class CompanyModel{
  final String name;
  final String phone;

  CompanyModel({required this.name, required this.phone});

  Map<String,String> toJson()=> {
      'name': name,
      'phone_number': phone
    };

}