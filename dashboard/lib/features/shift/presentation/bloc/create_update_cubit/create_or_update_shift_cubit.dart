import 'package:dashboard/core/error/failures.dart';
import 'package:dashboard/features/home/home_page.dart';
import 'package:dashboard/features/shift/data/models/shift_model.dart';
import 'package:dashboard/features/shift/domain/use_cases/create_shift_use_case.dart';
import 'package:dashboard/features/shift/domain/use_cases/shift_detail_use_case.dart';
import 'package:dashboard/features/shift/domain/use_cases/update_shift_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_or_update_shift_state.dart';

class CreateOrUpdateShiftCubit extends Cubit<CreateOrUpdateShiftState> {
  final CreateShiftUseCase createUseCase;
  final UpdateShiftUseCase updateUseCase;
  final ShiftDetailUseCase detailUseCase;

  CreateOrUpdateShiftCubit(
      this.createUseCase, this.updateUseCase, this.detailUseCase)
      : super(CreateOrUpdateShiftInitial());

  final name = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  var dayWeek = List.filled(7, false);

  final formKey = GlobalKey<FormState>();

  getDetail(int? id) async {
    if (id == null) return;
    print('get detail');
    emit(LoadingDataShiftState());
    final res = await detailUseCase(id: id);
    res.fold((l) {
      if (l.runtimeType == DetailsFailure) {
        l as DetailsFailure;
        emit(ErrorCreateOrUpdateShiftState(l.error));
      }
      emit(const ErrorCreateOrUpdateShiftState('error'));
    }, (r) {
      name.text = r.name;
      startTime.text = r.startTime;
      endTime.text = r.endTime;
      for (var ele in r.days) {
        dayWeek[ele - 1] = true;
      }
      emit(LoadedDataShiftState());
    });
  }

  Future<void> createOrUpdateShift({int? id}) async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    emit(LoadingDataShiftState());
    List<int> day = [];
    for (int i = 0; i < dayWeek.length; i++) {
      if (dayWeek[i]) day.add(DayWeek.values[i].value);
    }
    if (day.isEmpty) {
      emit(const ErrorCreateOrUpdateShiftState("day week can't be null"));
      return;
    }
    final shift = ShiftModel(
        id: -1,
        name: name.text,
        startTime: startTime.text,
        endTime: endTime.text,
        days: day);
    if (id == null) {
      final result = await createUseCase(shift: shift);
      result.fold((l) {
        if (l.runtimeType == DetailsFailure) {
          l as DetailsFailure;
          emit(ErrorCreateOrUpdateShiftState(l.error));
        }else {
          emit(const ErrorCreateOrUpdateShiftState('error'));
        }
      }, (r) => emit(CreateOrUpdateShiftSuccessState()));
      return;
    } else {
      final result = await updateUseCase(id: id, shift: shift);
      result.fold((l) {
        if (l.runtimeType == DetailsFailure) {
          l as DetailsFailure;
          emit(ErrorCreateOrUpdateShiftState(l.error));
        }else {
          emit(const ErrorCreateOrUpdateShiftState('error'));
        }
      }, (r) => emit(CreateOrUpdateShiftSuccessState()));
    }
  }

  void changeDay(bool value, int index) {
    dayWeek[index] = value;
    emit(ChangeDayShiftState());
  }
}
