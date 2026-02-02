import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/features/company/presentation/bloc/company_bloc.dart';
import 'package:pharmacy/features/company/presentation/pages/create_company.dart';
import 'package:pharmacy/injection_container.dart';

import '../../domain/entities/company.dart';

class AllCompany extends StatelessWidget {
  const AllCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CompanyBloc>(context);
    bloc.add(LoadCompaniesEvent());

    return BlocListener<CompanyBloc, CompanyState>(
        listener: (context, state) {
          if (state is ErrorFailureState) {
            myAwesomeDlg(
              context: context,
              type: DialogType.error,
              title: 'error',
              message: state.message,
            );
          } else if (state is FinishDeletingCompanyState) {
            myAwesomeDlg(
              context: context,
              type: DialogType.success,
              title: 'success',
              message: 'deleted successfully',
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body:
              BlocBuilder<CompanyBloc, CompanyState>(builder: (context, state) {
            return state is LoadingCompaniesState
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: bloc.allCom.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(bloc.allCom[index].name),
                        subtitle: Text(bloc.allCom[index].phone),
                        trailing: FittedBox(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    bloc.deletedCom = bloc.allCom[index];
                                    bloc.add(DeleteCompanyEvent());
                                  },
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => BlocProvider(
                                        create: (context) => sl<CompanyBloc>(),
                                        child: CreateCompany(company: Company(id: bloc.allCom[index].id,name: bloc.allCom[index].name, phone: bloc.allCom[index].phone )),
                                      ),
                                    );
                                    bloc.add(LoadCompaniesEvent());

                                  },
                                  icon: const Icon(Icons.edit)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => BlocProvider(
                  create: (context) => sl<CompanyBloc>(),
                  child: const CreateCompany(),
                ),
              );
              bloc.add(LoadCompaniesEvent());
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}
