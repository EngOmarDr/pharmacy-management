part of 'company_bloc.dart';

@immutable
abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class SuccessRequestState extends CompanyState {}

class ErrorState extends CompanyState {}

class LoadingState extends CompanyState {}

class LoadingCompaniesState extends CompanyState{}

class FinishLoadingCompaniesState extends CompanyState{}

class ErrorFailureState extends CompanyState {
  final String message;

  ErrorFailureState(this.message);
}

class FinishDeletingCompanyState extends CompanyState{}