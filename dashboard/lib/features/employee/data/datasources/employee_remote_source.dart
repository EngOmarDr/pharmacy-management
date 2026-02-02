import 'dart:convert';

import 'package:dashboard/features/employee/data/models/employee_model.dart';
import 'package:http/http.dart';
import 'package:dashboard/core/constant.dart';
import 'package:dashboard/core/error/exceptions.dart';

abstract class EmployeeRemoteSource {
  Future<void> createEmployee(
      {required int pharmacyId,
      required EmployeeModel employeeModel,
      required String accessToken});

  Future<List<(int id, String name)>> employeeList(
      int pharmacyId, String accessToken);

  Future<EmployeeModel> employeeDetails(
      int pharmacyId, int employeeId, String accessToken);

  Future<void> deleteEmployee(
      int pharmacyId, int employeeId, String accessToken);

  Future<void> updateEmployee(int pharmacyId, int employeeId,
      EmployeeModel employee, String accessToken);
}

class EmployeeRemoteSourceImpl implements EmployeeRemoteSource {
  @override
  Future<void> createEmployee(
      {required int pharmacyId,
      required EmployeeModel employeeModel,
      required String accessToken}) async {
    final response = await post(
      Uri.parse('http://${domain()}/api/pharmacy/$pharmacyId/employee/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
      body: json.encode(employeeModel.toJson()),
    );
    print('response status : ${json.decode(response.body)}');
    print('response status : ${response.statusCode}');
    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 400) {
      throw DetailsException(detail: json.decode(response.body)['errors']);
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> deleteEmployee(
      int pharmacyId, int employeeId, String accessToken) async {
    final response = await delete(
      Uri.parse(
          'http://${domain()}/api/pharmacy/$pharmacyId/employee/$employeeId/'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print('response status : ${response.statusCode}');
    print('response body : ${response.body}');
    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 400) {
      throw DetailsException(detail: json.decode(response.body)['errors']);
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<EmployeeModel> employeeDetails(
      int pharmacyId, int employeeId, String accessToken) async {
    final response = await get(
      Uri.parse(
          'http://${domain()}/api/pharmacy/$pharmacyId/employee/$employeeId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    print('response status : ${response.statusCode}');
    print('response status : ${response.body}');
    if (response.statusCode == 200) {
      return EmployeeModelUpdate.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 400) {
      throw DetailsException(detail: json.decode(response.body)['errors']);
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<List<(int id, String name)>> employeeList(
      int pharmacyId, String accessToken) async {
    final response = await get(
      Uri.parse('http://${domain()}/api/pharmacy/$pharmacyId/employee/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );
    print('response status : ${response.statusCode}');
    print('response status : ${jsonDecode(utf8.decode(response.bodyBytes))}');
    if (response.statusCode == 200) {
      final List res = (jsonDecode(utf8.decode(response.bodyBytes)));
      List<(int id, String name)> result = [];
      for (var ele in res) {
        result.add((ele['id'], ele['name']));
      }
      return result;
    } else if (response.statusCode == 400) {
      throw DetailsException(detail: json.decode(response.body)['errors']);
    } else {
      throw ServerErrorException();
    }
  }

  @override
  Future<void> updateEmployee(int pharmacyId, int employeeId,
      EmployeeModel updateEmployee, String accessToken) async {
    print(
        '${updateEmployee.employeeUpdateToJson()} $pharmacyId $employeeId  ${domain()}');
    final response = await put(
        Uri.parse(
            'http://${domain()}/api/pharmacy/$pharmacyId/employee/$employeeId/'),
        headers: {'Authorization': 'Bearer $accessToken'},
        body: updateEmployee.employeeUpdateToJson());
    print('response status : ${response.statusCode}');
    print('response status : ${response.body}');
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      throw DetailsException(detail: json.decode(response.body)['errors']);
    } else {
      throw ServerErrorException();
    }
  }
}
