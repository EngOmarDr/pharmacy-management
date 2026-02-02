part of 'create_update_pharmacy_cubit.dart';

@immutable
abstract class CreateOrUpdatePharmacyState {}

class CreateOrUpdatePharmacyInitial extends CreateOrUpdatePharmacyState {}

class LoadingState extends CreateOrUpdatePharmacyState {}

class CreateOrUpdatePharmacySuccessState extends CreateOrUpdatePharmacyState {}

class ErrorCreateOrUpdatePharmacyState extends CreateOrUpdatePharmacyState {
  final String? error;

  ErrorCreateOrUpdatePharmacyState({this.error});
}
