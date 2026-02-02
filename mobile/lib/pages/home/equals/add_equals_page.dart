import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/pages/home/equals/cubit/equals_cubit.dart';

class AddEqualsPage extends StatelessWidget {
  const AddEqualsPage({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<EqualsCubit>(context)
      ..getListMedicines(loginModel.tokens.access);
    return Scaffold(
      appBar: AppBar(
        title: const Text('add equals'),
      ),
      body: BlocBuilder<EqualsCubit, EqualsState>(
        builder: (context, state) {
          if (state is LoadingMedicinesState) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.medicines.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 1,
                      ),
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                              title: Text(cubit.medicines[index].$2),
                              onTap: () {
                                cubit.addOrDeleteMedicine(
                                    cubit.medicines[index]);
                                // Navigator.pop(context);
                              }),
                        );
                      },
                    ),
                    if (state is LoadingCreatingEqualsState) ...[
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ] else ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.selectedMedicines.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cubit.addOrDeleteMedicine(
                                    cubit.selectedMedicines[index],
                                    isAdd: false);
                              },
                            ),
                            title: Text(cubit.selectedMedicines[index].$2),
                          );
                        },
                      ),
                    ],
                    ElevatedButton(
                        onPressed: () {
                          cubit.addEquals(loginModel.tokens.access);
                        },
                        child: const Text('submit'))
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
