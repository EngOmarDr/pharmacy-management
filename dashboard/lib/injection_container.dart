import 'package:dashboard/features/employee/data/datasources/employee_remote_source.dart';
import 'package:dashboard/features/employee/data/repositories/employee_repo_impl.dart';
import 'package:dashboard/features/employee/domain/repositories/employee_repo.dart';
import 'package:dashboard/features/employee/domain/usecases/create_employee_use_case.dart';
import 'package:dashboard/features/employee/domain/usecases/delete_employee_use_case.dart';
import 'package:dashboard/features/employee/domain/usecases/employee_details_use_case.dart';
import 'package:dashboard/features/employee/domain/usecases/employee_list_use_case.dart';
import 'package:dashboard/features/employee/domain/usecases/update_employee_use_case.dart';
import 'package:dashboard/features/pharmacy/presentation/bloc/all_pharmacies/all_pharmacies_cubit.dart';
import 'package:dashboard/features/pharmacy/presentation/bloc/create_update_pharmacy/create_update_pharmacy_cubit.dart';
import 'package:dashboard/features/shift/data/data_sources/shift_remote_source.dart';
import 'package:dashboard/features/shift/data/repositories/shift_repositories_impl.dart';
import 'package:dashboard/features/shift/domain/repositories/shift_repositories.dart';
import 'package:dashboard/features/shift/domain/use_cases/all_shift_use_case.dart';
import 'package:dashboard/features/shift/domain/use_cases/create_shift_use_case.dart';
import 'package:dashboard/features/shift/domain/use_cases/delete_shift_use_case.dart';
import 'package:dashboard/features/shift/domain/use_cases/shift_detail_use_case.dart';
import 'package:dashboard/features/shift/domain/use_cases/update_shift_use_case.dart';
import 'package:dashboard/features/shift/presentation/bloc/create_update_cubit/create_or_update_shift_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'core/network_info.dart';
import 'features/auth/data/dataSources/auth_local_source.dart';
import 'features/auth/data/dataSources/auth_remote_source.dart';
import 'features/auth/data/repositories/auth_repo_imp.dart';
import 'features/auth/domain/repositories/auth_repo.dart';
import 'features/auth/domain/useCases/change_password_usecase.dart';
import 'features/auth/domain/useCases/login_usecase.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/employee/presentation/bloc/all_employees_bloc/all_employees_bloc.dart';
import 'features/home/bloc/home_bloc.dart';
import 'features/pharmacy/data/data_source/remote_source.dart';
import 'features/pharmacy/data/repositories/pharmacy_repo_impl.dart';
import 'features/pharmacy/domain/repositories/pharmacy_repo.dart';
import 'features/pharmacy/domain/use_cases/all_pharmacies_use_case.dart';
import 'features/pharmacy/domain/use_cases/create_use_case.dart';
import 'features/pharmacy/domain/use_cases/delete_use_case.dart';
import 'features/pharmacy/domain/use_cases/details_use_case.dart';
import 'features/pharmacy/domain/use_cases/update_use_case.dart';
import 'features/shift/presentation/bloc/all_shift_cubit/all_shift_cubit.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  //features

  //bloc
  sl.registerFactory<HomeBloc>(() => HomeBloc());

  ///  auth
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

  /// pharmacy

  //bloc
  sl.registerFactory<CreateOrUpdatePharmacyCubit>(() =>
      CreateOrUpdatePharmacyCubit(createUseCase: sl(), updateUseCase: sl()));
  sl.registerFactory<AllPharmaciesCubit>(() => AllPharmaciesCubit(
      deletePharmacyUseCase: sl(), allPharmaciesUseCase: sl()));

  //  Repository
  sl.registerLazySingleton<PharmacyRepositories>(() => PharmacyRepoImpl(
      authLocalSource: sl(), networkInfo: sl(), pharmacyRemoteSource: sl()));

  // data source
  sl.registerLazySingleton<PharmacyRemoteSource>(
      () => PharmacyRemoteSourceImpl1());

  // Use Case
  sl.registerLazySingleton(() => CreatePharmacyUseCase(repo: sl()));
  sl.registerLazySingleton(() => DeletePharmacyUseCase(repo: sl()));
  sl.registerLazySingleton(() => UpdatePharmacyUseCase(repo: sl()));
  sl.registerLazySingleton(() => DetailsPharmacyUseCase(repository: sl()));
  sl.registerLazySingleton(() => AllPharmaciesUseCase(repository: sl()));

  /// employees
  // bloc
  sl.registerFactory<AllEmployeesBloc>(
      () => AllEmployeesBloc(allEmp: sl(), deleteEmp: sl()));
  // sl.registerFactory<CreateOrUpdateEmployeeCubit>(() =>
  //     CreateOrUpdateEmployeeCubit(
  //         createUseCase: sl(), allShiftUseCase: sl(), empDetailUseCase: sl(),updateUseCase: sl(),
  //     pharID: ));

  // data source
  sl.registerLazySingleton<EmployeeRemoteSource>(
      () => EmployeeRemoteSourceImpl());

  // repository
  sl.registerLazySingleton<EmployeeRepositories>(() => EmployeeRepoImpl(
      authLocalSource: sl(), networkInfo: sl(), remoteSource: sl()));

  //use Case
  sl.registerLazySingleton<EmployeeListUseCase>(
      () => EmployeeListUseCase(repository: sl()));
  sl.registerLazySingleton<EmployeeDetailsUseCase>(
      () => EmployeeDetailsUseCase(repository: sl()));
  sl.registerLazySingleton<CreateEmployeeUseCase>(
      () => CreateEmployeeUseCase(repository: sl()));
  sl.registerLazySingleton<DeleteEmployeeUseCase>(
      () => DeleteEmployeeUseCase(repository: sl()));
  sl.registerLazySingleton<UpdateEmployeeUseCase>(
          () => UpdateEmployeeUseCase(repository: sl()));

  ///shift
  // data source
  sl.registerLazySingleton<ShiftRemoteSource>(() => ShiftRemoteSourceImpl());

  // repository
  sl.registerLazySingleton<ShiftRepositories>(
      () => ShiftRepositoriesImpl(sl(), sl(), sl()));
  // bloc
  sl.registerFactory<AllShiftCubit>(
      () => AllShiftCubit(allShiftUseCase: sl(), deleteShiftUseCase: sl()));
  sl.registerFactory<CreateOrUpdateShiftCubit>(
      () => CreateOrUpdateShiftCubit(sl(), sl(), sl()));

  //use Case
  sl.registerFactory<AllShiftUseCase>(() => AllShiftUseCase(repo: sl()));
  sl.registerFactory<CreateShiftUseCase>(() => CreateShiftUseCase(repo: sl()));
  sl.registerFactory<DeleteShiftUseCase>(() => DeleteShiftUseCase(repo: sl()));
  sl.registerFactory<UpdateShiftUseCase>(() => UpdateShiftUseCase(repo: sl()));
  sl.registerFactory<ShiftDetailUseCase>(() => ShiftDetailUseCase(repo: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  // External
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));
  sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
}
