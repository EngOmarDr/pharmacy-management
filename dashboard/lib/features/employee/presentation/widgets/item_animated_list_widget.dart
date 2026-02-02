import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../bloc/all_employees_bloc/all_employees_bloc.dart';

class ItemAnimatedList extends StatelessWidget {
  const ItemAnimatedList(
      {Key? key, required this.bloc, required this.state, required this.index, required this.pharmacyID})
      : super(key: key);

  final AllEmployeesBloc bloc;
  final LoadedEmployeesState state;
  final int index;
  final int pharmacyID;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 7),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListTile(
              trailing: FittedBox(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            body: const Text(
                                'are you sure from delete !?'),
                            dialogType: DialogType.warning,
                            btnOkOnPress: () =>
                                bloc.add(DeleteEmployeeEvent(
                                    pharID: pharmacyID,
                                    empID: state.emp[index].$1,
                                    index: index,
                                    empList: const [])),
                            btnCancelOnPress: () {},
                          ).show();

                        },
                        icon: const Icon(Icons.delete)),
                    IconButton.outlined(
                        onPressed: () {
                          bloc.add(CreateOrUpdateEmployeeEvent(
                              pharID: pharmacyID,
                              context: context,
                              empId: state.emp[index].$1));
                        },
                        icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
              title: Text('${state.emp[index].$1} ${state.emp[index].$2}')),
        ),
      ),
    );
  }
}
