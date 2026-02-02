import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/features/employee/domain/usecases/delete_employee_use_case.dart';
import 'package:dashboard/features/employee/domain/usecases/employee_list_use_case.dart';
import 'package:dashboard/features/employee/presentation/bloc/create_update_employee_cubit/create_or_update_employee_cubit.dart';
import 'package:dashboard/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../pages/create_update_employee_page.dart';

part 'all_employees_event.dart';

part 'all_employees_state.dart';

class AllEmployeesBloc extends Bloc<AllEmployeesEvent, AllEmployeesState> {
  final EmployeeListUseCase allEmp;
  final DeleteEmployeeUseCase deleteEmp;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  AllEmployeesBloc({required this.deleteEmp, required this.allEmp})
      : super(AllEmployeesInitial()) {
    on<AllEmployeesEvent>((event, emit) async {
      if (event is GetEmployeesEvent) {
        emit(LoadingEmployeeState());
        final res = await allEmp(pharmacyId: event.pharmacyId);
        res.fold((l) {
          emit(ErrorEmployeesState(error: failure(l)));
        }, (r) {
          emit(LoadedEmployeesState(emp: r));
        });
      } else if (event is CreateOrUpdateEmployeeEvent) {
        final res = await Navigator.push(
          event.context,
          PageTransition(
            BlocProvider(
              create: (context) => CreateOrUpdateEmployeeCubit(
                updateUseCase: sl(),
                allShiftUseCase: sl(),
                createUseCase: sl(),
                empDetailUseCase: sl(),
                empID: event.empId,
                pharID: event.pharID
              ),
              child: CreateOrUpdateEmployeePage(
                  employeeId: event.empId, pharId: event.pharID),
            ),
          ),
        );
        if (res != null) add(GetEmployeesEvent(pharmacyId: event.pharID));
      } else if (event is DeleteEmployeeEvent) {
        // List<(int,String)> list = [(1,'fsd')];
        // event.empList.forEach((element) {list.add((element.$1,element.$2));});
        // var text;
        // try{
        //  text = list.removeAt(event.index);
        //
        // }on Exception {
        //   return;
        // }
        final result =
            await deleteEmp(pharmacyId: event.pharID, employeeId: event.empID);
        result.fold((l) {
          emit(ErrorEmployeesState(error: 'error'));
        }, (r) async {
          listKey.currentState?.removeItem(
            event.index,
            (context, animation) => SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
                    .chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 7),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ListTile(
                    trailing: FittedBox(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.delete)),
                          IconButton.outlined(
                              onPressed: () {}, icon: const Icon(Icons.edit)),
                        ],
                      ),
                    ),
                    title: const Text('{text.1} {text.2}'),
                  ),
                ),
              ),
            ),
            duration: const Duration(milliseconds: 500),
          );
          emit(DeleteSuccessState());
          add(GetEmployeesEvent(pharmacyId: event.pharID));
        });
      }
    });
  }

  String failure(Failure f) {
    if (f is ServerFailure) {
      return 'server error';
    } else if (f is UnKnownFailure) {
      return 'unknown error';
    } else {
      return 'offline error';
    }
  }
}
