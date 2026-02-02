import 'package:dashboard/features/employee/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  final int employeeId;
  final int pharmacyId;
  final int shiftId;
  final bool isActive;

  EmployeeModel(
      {required this.isActive,
      required this.employeeId,
      required this.shiftId,
      required this.pharmacyId,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.phoneNumber,
      required super.salary,
      required super.role,
      super.shift,
      super.rePassword = '',
      super.password = ''});

  EmployeeModel.create(
      {required this.isActive,
      required this.employeeId,
      required this.pharmacyId,
      required this.shiftId,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.phoneNumber,
      required super.salary,
      required super.role,
      required super.rePassword,
      required super.password,
      super.shift});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
      employeeId: json['id'],
      pharmacyId: json['pharmacy'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      salary: json['salry'],
      shift: json['shift'],
      role: json['role'],
      shiftId: json['shift']['id'],
      isActive: json['is_active'] ?? true);

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'salry': salary,
        'password': password,
        're_password': rePassword,
        'roles': role,
        'shift': '$shiftId'
      };

  Map<String, dynamic> employeeUpdateToJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'salry': '$salary',
        'roles': role,
        'shift': '$shiftId',
        'is_active': '$isActive',
      };
}

class EmployeeModelUpdate extends EmployeeModel {
  final (int, String) shiftEmp;
  final int id;

  EmployeeModelUpdate({
    required this.id,
    required this.shiftEmp,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    required super.salary,
    required super.role,
    required super.shiftId,
    super.password = '',
    super.rePassword = '',
    super.email = '',
    super.employeeId = -1,
    super.pharmacyId = -1,
    required super.isActive,
  });

  factory EmployeeModelUpdate.fromJson(Map<String, dynamic> json) {
    // List<(int id, String name)> getShiftEmp = [];
    // for (var element in [json['shift']]) {
    //   getShiftEmp.add((element['id'], element['name']));
    // }
    return EmployeeModelUpdate(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        salary: json['salry'],
        role: json['roles'],
        shiftEmp: (json['shift']['id'], json['shift']['name']),
        shiftId: json['shift']['id'],
        isActive: json['is_active'] ?? true);
  }
}
