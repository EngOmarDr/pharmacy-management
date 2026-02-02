import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/all_employees_bloc/all_employees_bloc.dart';
import '../widgets/item_animated_list_widget.dart';

class AllEmployeePage extends StatelessWidget {
  const AllEmployeePage({Key? key, required this.pharmacyId}) : super(key: key);

  final int pharmacyId;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AllEmployeesBloc>(context)
      ..add(GetEmployeesEvent(pharmacyId: pharmacyId));

    return BlocListener<AllEmployeesBloc, AllEmployeesState>(
      listener: (context, state) {
        if (state is ErrorEmployeesState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'error',
            desc: 'state.message error',
            btnOkOnPress: () {},
          ).show();
        } else if (state is DeleteSuccessState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'success',
            desc: 'delete successfully',
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('all employees'),),
        body: BlocBuilder<AllEmployeesBloc, AllEmployeesState>(
          builder: (context, state) {
            if (state is LoadedEmployeesState) {
              return state.emp.isNotEmpty
                  ? RefreshIndicator(
                onRefresh: () async {
                  bloc.add(GetEmployeesEvent(pharmacyId: pharmacyId));
                },
                child: AnimatedList(
                  key: bloc.listKey,
                  shrinkWrap: true,
                  initialItemCount: state.emp.length,
                  padding: const EdgeInsets.all(15),
                  itemBuilder: (context, index, animation) {
                    return SlideTransition(
                      position: animation.drive(Tween<Offset>(
                          begin: const Offset(-1, 0), end: const Offset(0, 0)
                      )),
                      child: ItemAnimatedList(bloc: bloc,state: state,index: index,pharmacyID: pharmacyId),
                    );
                  },
                ),
              )
                  : const Center(child: Text("you don't have employee yet"));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bloc.add(CreateOrUpdateEmployeeEvent(
                context: context, pharID: pharmacyId));
          },
          tooltip: 'add employee',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

