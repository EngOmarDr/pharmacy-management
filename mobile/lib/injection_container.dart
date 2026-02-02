import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pharmacy/features/auth/data/dataSources/auth_local_source.dart';
import 'package:pharmacy/features/auth/data/dataSources/auth_remote_source.dart';
import 'package:pharmacy/features/auth/domain/useCases/login_usecase.dart';
import 'package:pharmacy/features/company/data/repositories/company_repo_impl.dart';
import 'package:pharmacy/features/company/domain/repositories/company_repositories.dart';
import 'package:pharmacy/features/company/domain/use_cases/create_company_use_case.dart';
import 'package:pharmacy/features/company/domain/use_cases/delete_company_use_case.dart';
import 'package:pharmacy/features/company/domain/use_cases/details_company_use_case.dart';
import 'package:pharmacy/features/company/domain/use_cases/list_company_use_case.dart';
import 'package:pharmacy/features/company/domain/use_cases/update_company_use_case.dart';
import 'package:pharmacy/features/pharmacy/data/data_source/remote_source.dart';
import 'package:pharmacy/features/pharmacy/data/repositories/pharmacy_repo_impl.dart';
import 'package:pharmacy/features/pharmacy/domain/repositories/pharmacy_repo.dart';
import 'package:pharmacy/features/pharmacy/domain/use_cases/all_pharmacies_use_case.dart';
import 'package:pharmacy/features/pharmacy/domain/use_cases/delete_use_case.dart';
import 'package:pharmacy/features/pharmacy/domain/use_cases/details_use_case.dart';
import 'package:pharmacy/features/pharmacy/domain/use_cases/update_use_case.dart';

import 'core/network_info.dart';
import 'features/auth/data/repositories/auth_repo_imp.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/useCases/change_password_usecase.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/company/data/data_sources/company_remote_source.dart';
import 'features/company/presentation/bloc/company_bloc.dart';
import 'features/medicine/presentation/bloc/create_medicine/add_medicine_bloc.dart';
import 'features/medicine/presentation/bloc/sale_medicine/sale_medicine_bloc.dart';
import 'features/pharmacy/domain/use_cases/create_use_case.dart';
import 'pages/home/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerFactory<HomeBloc>(() => HomeBloc());

  /// features

  /// auth
  // Bloc
  sl.registerFactory<LoginBloc>(() => LoginBloc(login: sl()));

  // useCases
  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepo>(() =>
      AuthRepoImp(remoteSource: sl(), localSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSourceImpl1());
  sl.registerLazySingleton<AuthLocalSource>(
      () => AuthLocalSourceImpl1(secureStorage: sl()));
  /// End Auth


  /// pharmacy
  //  Repository
  sl.registerLazySingleton<PharmacyRepositories>(() => PharmacyRepoImpl(
      authLocalSource: sl(), networkInfo: sl(), pharmacyRemoteSource: sl( )));

  // data source
  sl.registerLazySingleton<PharmacyRemoteSource>(() => PharmacyRemoteSourceImpl1());

  // Use Case
  sl.registerLazySingleton(() => CreatePharmacyUseCase(repo: sl()));
  sl.registerLazySingleton(() => DeletePharmacyUseCase(repo: sl()));
  sl.registerLazySingleton(() => UpdatePharmacyUseCase(repo: sl()));
  sl.registerLazySingleton(() => DetailsPharmacyUseCase(repository: sl()));
  sl.registerLazySingleton(() => AllPharmaciesUseCase(repository: sl()));

///medicine
  //bloc
  sl.registerFactory(() => AddMedicineBloc());
  sl.registerFactory(() => SaleMedicineBloc());

  /// company
  // Bloc
  sl.registerFactory<CompanyBloc>(() => CompanyBloc(createCom: sl(), listCom: sl(), deleteCom: sl(), updateCom: sl()));

  // useCases
  sl.registerLazySingleton<CreateCompanyUseCase>(() => CreateCompanyUseCase(sl()));
  sl.registerLazySingleton<UpdateCompanyUseCase>(() => UpdateCompanyUseCase(sl()));
  sl.registerLazySingleton<DeleteCompanyUseCase>(() => DeleteCompanyUseCase(sl()));
  sl.registerLazySingleton<DetailsCompanyUseCase>(() => DetailsCompanyUseCase(sl()));
  sl.registerLazySingleton<ListCompanyUseCase>(() => ListCompanyUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CompanyRepositories>(() =>
      CompanyRepoImpl(authLocalSource: sl(),companyRemoteSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<CompanyRemoteSource>(() => CompanyRemoteSourceImpl1());
  // sl.registerLazySingleton<AuthLocalSource>(
  //         () => AuthLocalSourceImpl1(secureStorage: sl()));
  /// End company

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  // External
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
}
