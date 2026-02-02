import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/features/shift/domain/use_cases/all_shift_use_case.dart';
import 'package:dashboard/features/shift/domain/use_cases/delete_shift_use_case.dart';
import 'package:dashboard/features/shift/presentation/pages/create_update_shift_page.dart';
import 'package:flutter/material.dart';

import '../create_update_cubit/create_or_update_shift_cubit.dart';

part 'all_shift_state.dart';

class AllShiftCubit extends Cubit<AllShiftState> {
  final AllShiftUseCase allShiftUseCase;
  final DeleteShiftUseCase deleteShiftUseCase;
  final listKey = GlobalKey<AnimatedListState>();

  AllShiftCubit(
      {required this.allShiftUseCase, required this.deleteShiftUseCase})
      : super(LoadingAllShiftState()) {
    getAllShift();
  }

  Future<void> getAllShift() async {
    // emit(LoadingAllShiftState());
    final result = await allShiftUseCase();
    result.fold((l) {
      emit(ErrorShiftState('errorMessage'));
    }, (r) {
      print(r);
      emit(LoadedAllShiftState(r));
    });
  }

  Future<void> deleteShift(
      int id, List<(int, String)> allShift, int index) async {
    // emit(LoadingAllShiftState());
    final result = await deleteShiftUseCase(id: id);
    result.fold((failure) {
      if(failure is DetailsFailure) {
        emit(ErrorShiftState(failure.error));
      }else {
        emit(ErrorShiftState('error'));
      }
      emit(LoadedAllShiftState(allShift));
    }, (r) {
      (int, String) delItem = allShift.removeAt(index);
      listKey.currentState?.removeItem(
        duration: const Duration(milliseconds: 500),
        index,
        (context, animation) => SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(-1, 0), end: const Offset(0, 0))
                .chain(CurveTween(curve: Curves.easeInOutQuart)),
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 7),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ListTile(
                title: Text(delItem.$2),
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
              ),
            ),
          ),
        ),
      );
      emit(LoadedAllShiftState(allShift));
    });
  }

  Future<void> createOrUpdateShift(BuildContext context, {int? id}) async {
    final res = await Navigator.push(
        context,
        PageTransition(BlocProvider(
          create: (context) => sl<CreateOrUpdateShiftCubit>(),
          child: CreateOrUpdateShiftPage(id: id),
        )));
    if(res==true) getAllShift();
  }
}
