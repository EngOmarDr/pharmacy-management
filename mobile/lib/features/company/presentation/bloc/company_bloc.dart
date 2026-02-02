import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/features/company/data/models/company_model.dart';
import 'package:pharmacy/features/company/domain/entities/company.dart';
import 'package:pharmacy/features/company/domain/use_cases/delete_company_use_case.dart';
import 'package:pharmacy/features/company/domain/use_cases/update_company_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../domain/use_cases/create_company_use_case.dart';
import '../../domain/use_cases/list_company_use_case.dart';

part 'company_event.dart';

part 'company_state.dart';

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  final CreateCompanyUseCase createCom;
  final ListCompanyUseCase listCom;
  final DeleteCompanyUseCase deleteCom;
  final UpdateCompanyUseCase updateCom;
  List<Company> allCom = [];
  Company deletedCom = Company(id: -1, name: 'name', phone: 'phone');

  final name = TextEditingController();
  final phone = TextEditingController();

  CompanyBloc(
      {required this.updateCom,
      required this.deleteCom,
      required this.listCom,
      required this.createCom})
      : super(CompanyInitial()) {
    on<CompanyEvent>((event, emit) async {
      if (event is CreateCompanyEvent) {
        emit(LoadingState());
        final res = await createCom(companyModel: event.companyModel);
        res.fold((failure) {
          emit(ErrorState());
        }, (company) {
          emit(SuccessRequestState());
        });
      } else if (event is LoadCompaniesEvent) {
        emit(LoadingCompaniesState());
        print('object');
        final res = await listCom.call();
        res.fold((failure) {
          emit(ErrorFailureState(_failureType(failure)));
        }, (listCompany) {
          allCom = listCompany;
          print('$allCom 55');
          emit(FinishLoadingCompaniesState());
        });
      } else if (event is DeleteCompanyEvent) {
        emit(LoadingCompaniesState());
        final res = await deleteCom.call(companyID: deletedCom.id);
        res.fold((failure) {
          emit(ErrorFailureState(_failureType(failure)));
        }, (r) {
          final isDel = allCom.remove(deletedCom);
          isDel
              ? emit(FinishDeletingCompanyState())
              : emit(ErrorFailureState('not delete'));
        });
      } else if (event is UpdateCompanyEvent) {
        emit(LoadingCompaniesState());
        final res = await updateCom.call(
            companyID: deletedCom.id,
            companyModel:
                CompanyModel(name: deletedCom.name, phone: deletedCom.phone));
        res.fold((failure) {
          emit(ErrorFailureState(_failureType(failure)));
        }, (r) {
          allCom = allCom.where(
            (element) {
              if (element.id == deletedCom.id) {
                element = deletedCom;
                return true;
              }
              return true;
            },
          ).toList();
          emit(FinishDeletingCompanyState());
        });
      }
    });
  }

  String _failureType(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'server error';
      case OfflineFailure:
        return 'no internet connection';
      case CacheFailure:
        return 'cache error try again';
      case DataNotCompleteFailure:
        failure as DataNotCompleteFailure;
        return failure.message;
      case DetailsFailure:
        failure as DetailsFailure;
        return failure.message;
      default:
        return 'Unknown Error';
    }
  }
}
