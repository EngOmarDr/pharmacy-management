import 'package:dashboard/features/home/bloc/home_bloc.dart';
import 'package:dashboard/features/shift/domain/entities/shift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationRailWidget extends StatelessWidget {
  const NavigationRailWidget({Key? key}) : super(key: key);

  static final type = HomeBloc.loginModel!.type;

  @override
  Widget build(BuildContext context) {
    final List<NavigationRailDestination> listDes =
        HomeBloc.loginModel!.type == Role.manager.value
            ? const [
                NavigationRailDestination(
                    icon: Icon(Icons.dashboard), label: Text('dashboard')),
                NavigationRailDestination(
                    icon: Icon(Icons.domain), label: Text('all Pharmacies')),
                NavigationRailDestination(
                    icon: Icon(Icons.access_time_sharp),
                    label: Text('all shift')),
                NavigationRailDestination(
                    icon: Icon(Icons.logout), label: Text('logout')),
              ]
            : const [
                NavigationRailDestination(
                    icon: Icon(Icons.eight_mp), label: Text('all employee')),
                NavigationRailDestination(
                    icon: Icon(Icons.access_time_sharp),
                    label: Text('all shift')),
                NavigationRailDestination(
                    icon: Icon(Icons.logout), label: Text('logout')),
              ];
    print('rebuild nav rail ----------------------------');
    final bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return NavigationRail(
          extended: MediaQuery.of(context).size.width >= 1100,
          labelType: MediaQuery.of(context).size.width >= 1100
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.all,
          selectedIndex: bloc.indexNavBar,

          onDestinationSelected: (int index) {
            if (index == 3 && type == Role.manager.value) {
              bloc.add(LogoutEvent(context: context));
              return;
            }
            if (index == 2 && type == Role.pharmacyManager.value) {
              bloc.add(LogoutEvent(context: context));
              return;
            }
            bloc.add(ChangeHomeWidgetEvent(context, index: index, type: type));
          },
          destinations: listDes,
        );
      },
    );
  }
}
