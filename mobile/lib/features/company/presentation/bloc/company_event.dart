part of 'company_bloc.dart';

@immutable
abstract class CompanyEvent {}

class CreateCompanyEvent implements CompanyEvent{
  final CompanyModel companyModel;

  CreateCompanyEvent(this.companyModel);
}

class LoadCompaniesEvent implements CompanyEvent {}


class DeleteCompanyEvent implements CompanyEvent {}
class UpdateCompanyEvent implements CompanyEvent {}