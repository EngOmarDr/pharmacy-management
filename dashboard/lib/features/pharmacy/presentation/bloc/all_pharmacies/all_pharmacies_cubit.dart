import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:dashboard/features/pharmacy/domain/use_cases/all_pharmacies_use_case.dart';
import 'package:dashboard/features/pharmacy/domain/use_cases/delete_use_case.dart';
import 'package:dashboard/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../auth/data/dataSources/auth_local_source.dart';
import '../../../../auth/presentation/bloc/login_bloc.dart';
import '../../../domain/entities/pharmacy.dart';
import '../../pages/create_update_pharmacy_page.dart';
import '../create_update_pharmacy/create_update_pharmacy_cubit.dart';

part 'all_pharmacies_state.dart';

class AllPharmaciesCubit extends Cubit<AllPharmaciesState> {
  AllPharmaciesCubit(
      {required this.deletePharmacyUseCase, required this.allPharmaciesUseCase})
      : super(GetPharmaciesState()){
    getPharmacies();
  }

  final AllPharmaciesUseCase allPharmaciesUseCase;
  final DeletePharmacyUseCase deletePharmacyUseCase;

  List<Pharmacy> allPharmacies = List.empty(growable: true);

  Future<void> getPharmacies() async {
    emit(GetPharmaciesState());
    final result = await allPharmaciesUseCase();
    result.fold((l) => emit(ErrorGetPharmaciesState()), (allPhar) {
      allPharmacies = allPhar;
      emit(LoadedPharmaciesState(allPharmacies));
    });
  }

  Future<void> deletePharmacy(int index) async {
    emit(DeletePharmacyState());
    final result = await deletePharmacyUseCase(allPharmacies[index].id);
    result.fold((l) => emit(ErrorGetPharmaciesState()), (_) {
      allPharmacies.removeAt(index);
      emit(LoadedPharmaciesState(allPharmacies));
    });
  }

  Future<void> createOrUpdatePharmacy(
      BuildContext context, Pharmacy? pharmacy) async {
    final res = await Navigator.push(
      context,
      PageTransition(
        BlocProvider<CreateOrUpdatePharmacyCubit>(
          create: (context) => sl(),
          child: CreatePharmacyPage(pharmacy: pharmacy),
        ),
      ),
    );
    if (res != null) await getPharmacies();
  }

  logout({required BuildContext context}) async {
    AuthLocalSource auth = AuthLocalSourceImpl1(secureStorage: sl());
    await auth.deleteAuthData().then(
      (value) {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
              BlocProvider(
                create: (_) => sl<LoginBloc>(),
                child: const LoginPage(),
              ),
            ),
            (route) => false);
      },
    );
  }
}
