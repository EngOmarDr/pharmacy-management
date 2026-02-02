import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/features/auth/data/dataSources/auth_local_source.dart';
import 'package:dashboard/features/auth/data/models/login_model.dart';
import 'package:dashboard/features/auth/presentation/bloc/login_bloc.dart';
import 'package:dashboard/features/auth/presentation/pages/login_page.dart';
import 'package:dashboard/features/employee/presentation/bloc/all_employees_bloc/all_employees_bloc.dart';
import 'package:dashboard/features/employee/presentation/pages/all_employees_page.dart';
import 'package:dashboard/features/home/dashboard/dashbord_page.dart';
import 'package:dashboard/features/pharmacy/domain/entities/pharmacy.dart';
import 'package:dashboard/features/pharmacy/presentation/bloc/all_pharmacies/all_pharmacies_cubit.dart';
import 'package:dashboard/features/pharmacy/presentation/pages/all_pharmacies_page.dart';
import 'package:dashboard/features/shift/domain/entities/shift.dart';
import 'package:dashboard/features/shift/presentation/bloc/all_shift_cubit/all_shift_cubit.dart';
import 'package:dashboard/features/shift/presentation/bloc/create_update_cubit/create_or_update_shift_cubit.dart';
import 'package:dashboard/features/shift/presentation/pages/all_shift_page.dart';
import 'package:dashboard/features/shift/presentation/pages/create_update_shift_page.dart';
import 'package:dashboard/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  int indexNavBar = 0;
  String title = 'All Pharmacy';
  static LoginModel? loginModel;
  bool toggle = true;

  final List<String> titleList = loginModel!.type == Role.manager.value
      ? [
          'dashboard',
          'all pharmacies',
          'all shift',
          'create shift',
        ]
      : ['all employee', 'all shift', 'create shift'];

  List<Widget> widgetList() {
    return loginModel!.type == Role.manager.value
        ? [
      BlocProvider(
        create: (ctx) => sl<AllPharmaciesCubit>(),
        child: DashboardPage(loginModel: loginModel!,),
      ),
            BlocProvider(
              create: (ctx) => sl<AllPharmaciesCubit>(),
              child: const AllPharmaciesPage(),
            ),
            BlocProvider(
              create: (context) => sl<AllShiftCubit>(),
              child: const AllShiftPage(),
            ),
            BlocProvider(
              create: (context) => sl<CreateOrUpdateShiftCubit>(),
              child: const CreateOrUpdateShiftPage(),
            ),
          ]
        : [
            BlocProvider(
              create: (context) => sl<AllEmployeesBloc>(),
              child: AllEmployeePage(pharmacyId: loginModel!.pharmacyId!),
            ),
            BlocProvider(
              create: (context) => sl<AllShiftCubit>(),
              child: const AllShiftPage(),
            ),
            BlocProvider(
              create: (context) => sl<CreateOrUpdateShiftCubit>(),
              child: const CreateOrUpdateShiftPage(),
            ),
          ];
  }

  List isSel = List.generate(6, (index) => index == 0 ? true : false);

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>(
      (event, emit) async {
        switch (event.runtimeType) {
          case ChangeNavigationBarEvent:
            event as ChangeNavigationBarEvent;
            indexNavBar = event.index;
            emit(ChangeNavigationBarState());
            break;
          case ChangeHomeWidgetEvent:
            event as ChangeHomeWidgetEvent;
            if (indexNavBar == event.index) return;
            title = titleList[event.index];
            isSel = List.filled(6, false);
            isSel[event.index] = true;
            indexNavBar = event.index;
            emit(ChangeHomeWidgetState());
            break;

          case LogoutEvent:
            event as LogoutEvent;
            AuthLocalSource auth = AuthLocalSourceImpl1(secureStorage: sl());
            await auth.deleteAuthData().then(
              (value) {
                Navigator.pushAndRemoveUntil(
                    event.context,
                    PageTransition(BlocProvider(
                      create: (_) => sl<LoginBloc>(),
                      child: const LoginPage(),
                    )),
                    (route) => false);
              },
            );
          case ChangeThemeEvent:
            toggle = !toggle;
                emit(ChangeThemeState());
        }
      },
    );
  }
}
