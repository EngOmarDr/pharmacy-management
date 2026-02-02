part of 'create_or_update_shift_cubit.dart';

abstract class CreateOrUpdateShiftState{
  const CreateOrUpdateShiftState();
}

class CreateOrUpdateShiftInitial extends CreateOrUpdateShiftState {

}

class LoadingDataShiftState extends CreateOrUpdateShiftState{

}

class LoadedDataShiftState extends CreateOrUpdateShiftState{
  }

class ChangeDayShiftState extends CreateOrUpdateShiftState{
  }

class CreateOrUpdateShiftSuccessState extends CreateOrUpdateShiftState{
}

class ErrorCreateOrUpdateShiftState extends CreateOrUpdateShiftState {
  final String message;

  const ErrorCreateOrUpdateShiftState(this.message);
  }
