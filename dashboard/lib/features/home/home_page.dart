import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/features/auth/data/models/login_model.dart';
import 'package:dashboard/features/pharmacy/presentation/bloc/all_pharmacies/all_pharmacies_cubit.dart';
import 'package:dashboard/features/pharmacy/presentation/pages/all_pharmacies_page.dart';
import 'package:dashboard/features/shift/domain/entities/shift.dart';
import 'package:dashboard/features/shift/presentation/bloc/all_shift_cubit/all_shift_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';
import '../shift/presentation/bloc/create_update_cubit/create_or_update_shift_cubit.dart';
import '../shift/presentation/pages/all_shift_page.dart';
import '../shift/presentation/pages/create_update_shift_page.dart';
import 'bloc/home_bloc.dart';
import 'in_active_users_page.dart';
import 'notifiaction_page.dart';
import 'widgets/navigation_rail_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.loginModel}) : super(key: key);

  final LoginModel loginModel;

  @override
  Widget build(BuildContext context) {
    HomeBloc.loginModel = loginModel;
    final bloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: MediaQuery.of(context).size.width < 850
          ? AppBar(
              centerTitle: true,
              title: Text(bloc.titleList[bloc.indexNavBar]).tr(),
            )
          : null,
      drawer: MediaQuery.of(context).size.width < 850
          ? Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    if (HomeBloc.loginModel?.type == Role.manager.value)
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(BlocProvider(
                                  create: (context) => sl<AllPharmaciesCubit>(),
                                  child: const AllPharmaciesPage())));
                        },
                        title: const Text('All pharmacies').tr(),
                      ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(BlocProvider(
                                create: (context) => sl<AllShiftCubit>(),
                                child: const AllShiftPage())));
                      },
                      title: const Text('All shift').tr(),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(BlocProvider(
                              create: (context) =>
                                  sl<CreateOrUpdateShiftCubit>(),
                              child: const CreateOrUpdateShiftPage(),
                            )));
                      },
                      title: const Text('shift create').tr(),
                    ),
                    ListTile(
                      title: const Text('in active users').tr(),
                      onTap: () async {
                        Navigator.of(context).push(PageTransition(
                            InActiveUsersPage(pharmacyId: loginModel.pharmacyId ,token: loginModel.tokens.access,)
                        ));
                      },
                    ),
                    ListTile(
                      title: const Text('notification').tr(),
                      trailing: const Icon(Icons.notifications_active_outlined),
                      onTap: () async {
                        Navigator.of(context).push(PageTransition(
                            NotificationPage(pharmacyId: loginModel.pharmacyId ?? 1,token: loginModel.tokens.access,)
                        ));
                      },
                    ),
                    const Divider(color: Colors.grey),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return SwitchListTile(
                            value: bloc.toggle,
                            onChanged: (value) {
                              print(bloc.toggle);
                              bloc.toggle
                                  ? AdaptiveTheme.of(context).setDark()
                                  : AdaptiveTheme.of(context).setLight();
                              bloc.add(ChangeThemeEvent());
                            },
                            title: const Text('theme').tr());
                      },
                    ),
                    SwitchListTile(
                        value: context.locale.languageCode == 'en',
                        onChanged: (value) {
                          if (value) {
                            context.setLocale(const Locale('en'));
                          } else {
                            context.setLocale(const Locale('ar'));
                          }
                        },
                        title: const Text('language').tr()),
                    ListTile(
                      onTap: () {
                        bloc.add(LogoutEvent(context: context));
                      },
                      title: const Text('logout').tr(),
                    ),
                    const Image(
                      height: 300,
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/logo2.png'),
                    ),
                  ],

                ),
              ),
            )
          : null,
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) => current is ChangeHomeWidgetState,
        builder: (context, state) {
          return Row(
            children: [
              if (MediaQuery.of(context).size.width >= 850)
                const NavigationRailWidget(),
              Expanded(
                child: bloc.widgetList()[bloc.indexNavBar],
              )
            ],
          );
        },
      ),
    );
  }
}

enum DayWeek {
  sat(1, 'Saturday', ''),
  sun(2, 'Sunday', ''),
  mon(3, 'Monday', ''),
  tue(4, 'Tuesday', ''),
  wed(5, 'Wednesday', ''),
  thu(6, 'Thursday', ''),
  fri(7, 'Friday', '');

  final String nameEn;
  final String nameAr;
  final int value;

  const DayWeek(this.value, this.nameEn, this.nameAr);
}

// appBar: MediaQuery.of(context).size.width < 850
//     ? AppBar(centerTitle: true,
//         title: Text(loginModel.type == Role.pharmacyManager.value
//             ? 'bloc.titleList[bloc.indexNavBar]'
//             : bloc.title),
//       )
//     : null,
// drawer: MediaQuery.of(context).size.width < 850
//     ? Drawer(
//         child: SafeArea(
//           child: ListView(
//             children: [
//               ListTile(
//                 onTap: () {
//                   bloc.add(LogoutEvent(context: context));
//                 },
//                 title: const Text('logout'),
//               ),
//               const Divider(color: Colors.grey),
//               ListTile(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       PageTransition(BlocProvider(
//                         create: (context) =>
//                             sl<CreateOrUpdateShiftCubit>(),
//                         child: const CreateOrUpdateShiftPage(),
//                       )));
//                 },
//                 title: const Text('shift create'),
//               ),
//               ListTile(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       PageTransition(BlocProvider(
//                           create: (context) => sl<AllShiftCubit>(),
//                           child: const AllShiftPage())));
//                 },
//                 title: const Text('All shift'),
//               ),
//               const Image(
//                 image: AssetImage('assets/images/logo2.png'),
//               ),
//             ],
//           ),
//         ),
//       )
//     : null,
