part of 'all_shift_cubit.dart';

@immutable
abstract class AllShiftState {}

class LoadingAllShiftState extends AllShiftState {}

class LoadedAllShiftState extends AllShiftState {
  final List<(int id, String name)> allShift;

  LoadedAllShiftState(this.allShift);
}

class ErrorShiftState extends AllShiftState {
  final String errorMessage;

  ErrorShiftState(this.errorMessage);
}

