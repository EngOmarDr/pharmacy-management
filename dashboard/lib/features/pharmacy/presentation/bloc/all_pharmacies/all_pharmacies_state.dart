part of 'all_pharmacies_cubit.dart';

@immutable
abstract class AllPharmaciesState{}

class GetPharmaciesState extends AllPharmaciesState {}

class LoadedPharmaciesState extends AllPharmaciesState {
  final List<Pharmacy> pharmacies ;

  LoadedPharmaciesState(this.pharmacies);
}

class DeletePharmacyState extends AllPharmaciesState {}

class ErrorGetPharmaciesState extends AllPharmaciesState {}

