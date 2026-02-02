import 'package:dashboard/features/shift/domain/entities/shift.dart';

class Employee {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final int salary;
  final String password;
  final String rePassword;
  final String role;
  final Shift? shift;

  Employee({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.salary,
    required this.password,
    required this.phoneNumber,
    required this.rePassword,
    required this.role,
    this.shift,
  });

}
