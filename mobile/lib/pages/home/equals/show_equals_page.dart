import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/pages/home/equals/cubit/equals_cubit.dart';

// ignore: must_be_immutable
class ShowEqualsPage extends StatelessWidget {
  ShowEqualsPage({Key? key, required this.accessToken}) : super(key: key);

  final String accessToken;
  (int, String) med = (0, '');
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<EqualsCubit>(context)
      ..getListMedicines(accessToken);
    return Scaffold(
      appBar: AppBar(title: const Text('equals')),
      body: BlocBuilder<EqualsCubit, EqualsState>(builder: (context, state) {
        print(state);
        if (state is LoadingMedicinesState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.medicines.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 1,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    child: SizedBox(
                      child: ListTile(
                        title: Text(cubit.medicines[index].$2),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              body: const Text(
                                  'do you want delete it form equals'),
                              title: 'warnig',
                              dialogType: DialogType.warning,
                              btnOkOnPress: () async =>
                                  await cubit.deleteEquals(
                                      accessToken, cubit.medicines[index].$1),
                              btnCancelOnPress: () {},
                            ).show();
                          },
                        ),
                        onTap: () {
                          med = cubit.medicines[index];
                          cubit.getEquals(
                              accessToken, cubit.medicines[index].$1);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Text('equals for ${med.$2}'),
              const SizedBox(
                height: 25,
              ),
              if (state is LoadingCreatingEqualsState)
                const CircularProgressIndicator()
              else
                cubit.medicinesEqual == [] || cubit.medicinesEqual.isNotEmpty
                    ? Text('no equals for ${med.$2}')
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.medicinesEqual.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 1,
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                            child: SizedBox(
                              child: ListTile(
                                title: Text(cubit.medicinesEqual[index].$2),
                              ),
                            ),
                          );
                        },
                      ),
            ],
          );
        }
      }),
    );
  }
}
