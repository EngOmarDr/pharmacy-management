import 'package:dashboard/features/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

import '../responsive.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key, required this.titleApp, required this.bloc})
      : super(key: key);

  final String titleApp;
  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: () {
              if (!bloc.key.currentState!.isDrawerOpen) {
                bloc.key.currentState!.openDrawer();
              }
            },
            icon: const Icon(Icons.menu),
          ),
        FittedBox(child: Text(titleApp)),
      ],
    );
  }
}
