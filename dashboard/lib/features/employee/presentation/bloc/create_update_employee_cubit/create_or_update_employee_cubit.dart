import 'package:dartz/dartz.dart';
import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/employee/domain/usecases/create_employee_use_case.dart';
import 'package:dashboard/features/employee/domain/usecases/employee_details_use_case.dart';
import 'package:dashboard/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:dashboard/features/shift/domain/entities/shift.dart';
import 'package:dashboard/features/shift/domain/use_cases/all_shift_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/employee_model.dart';

part 'create_or_update_employee_state.dart';

class CreateOrUpdateEmployeeCubit extends Cubit<CreateOrUpdateEmployeeState> {
  final CreateEmployeeUseCase createUseCase;
  final AllShiftUseCase allShiftUseCase;
  final EmployeeDetailsUseCase empDetailUseCase;
  final UpdateEmployeeUseCase updateUseCase;
  final int? empID;
  final int pharID;

  CreateOrUpdateEmployeeCubit(
      {this.empID,
      required this.pharID,
      required this.updateUseCase,
      required this.empDetailUseCase,
      required this.allShiftUseCase,
      required this.createUseCase})
      : super(CreateOrUpdateEmployeeInitial()) {
    getShift().then((value) {
      getEmpDetail(empID, pharID);
    });
  }

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final salary = TextEditingController();
  final pass = TextEditingController();
  final rePass = TextEditingController();
  final key = GlobalKey<FormState>();

  int shiftId = -1;
  bool isObscure = true;
  String role = Role.values[0].value;
  String? shift;
  bool isActive = true;
  void changeObscure() {
    isObscure = !isObscure;
    emit(ChangeObscurePasswordState());
  }

  void changeRadio(String value, int index) {
    role = value;
    print(value);
    emit(ChangeRadioState());
  }

  void changeActive(bool value) {
    isActive = value;
    emit(ChangeActiveState());
  }

  Future<void> createEmployee() async {
    if (!key.currentState!.validate()) return;
    if (pass.text != rePass.text) {
      emit(ErrorCreateOrUpdateEmployeeState(
          error: "password and re password didn't match"));
      return;
    }
    emit(LoadingCreateEmployeeState());
    EmployeeModel e = EmployeeModel(
      pharmacyId: -1,
      employeeId: -1,
      shiftId: shiftId,
      firstName: firstName.text,
      lastName: lastName.text,
      phoneNumber: phone.text,
      email: email.text,
      password: pass.text,
      rePassword: rePass.text,
      role: role,
      salary: int.parse(salary.text), isActive: isActive,
    );
    print('$pharID $empID');
    Either<Failure, Unit> res;
    if (empID == null) {
      res = await createUseCase(pharmacyId: pharID, employee: e);
    } else {
      res = await updateUseCase(
          pharmacyId: pharID, employeeId: empID!, employee: e);
    }
    res.fold((failure) {
      print('=========================== ${failure.runtimeType}');
      if (failure.runtimeType == DetailsFailure) {
        failure as DetailsFailure;
        emit(ErrorCreateOrUpdateEmployeeState(error: failure.error));
      } else {
        emit(ErrorCreateOrUpdateEmployeeState(error: 'error'));
      }
    }, (r) => emit(LoadedCreateEmployeeState()));
  }

  List<(int, String)> listShift = [];

  Future<void> getShift() async {
    emit(LoadingShiftState());
    final result = await allShiftUseCase();
    result.fold((failure) {
      if (failure.runtimeType == DetailsFailure) {
        failure as DetailsFailure;
        emit(ErrorCreateOrUpdateEmployeeState(error: failure.error));
      } else {
        emit(ErrorCreateOrUpdateEmployeeState(error: 'error'));
      }
    }, (r) {
      listShift = r;
      emit(LoadedShiftState(r));
    });
  }

  Future<void> getEmpDetail(int? empID, int pharID) async {
    if (empID == null) {
      shift = '';
      return;
    }
    emit(GetEmpDetailState());
    final result =
        await empDetailUseCase(employeeId: empID, pharmacyId: pharID);
    result.fold((failure) {
      emit(ErrorCreateOrUpdateEmployeeState(error: 'error'));
    }, (empModel) {
      empModel as EmployeeModelUpdate;
      print(empModel);
      firstName.text = empModel.firstName;
      lastName.text = empModel.lastName;
      phone.text = empModel.phoneNumber;
      salary.text = empModel.salary.toString();
      shiftId = empModel.shiftId;
      role = empModel.role;
      shift = empModel.shiftEmp.$2;
      shiftId = empModel.shiftEmp.$1;
      print(shift);
      emit(FinishEmpDetailState());
    });
  }
}
