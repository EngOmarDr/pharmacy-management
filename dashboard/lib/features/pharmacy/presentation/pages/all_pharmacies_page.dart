import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dashboard/core/constant.dart';
import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/features/employee/presentation/pages/all_employees_page.dart';
import 'package:dashboard/features/pharmacy/presentation/bloc/all_pharmacies/all_pharmacies_cubit.dart';
import 'package:dashboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../employee/presentation/bloc/all_employees_bloc/all_employees_bloc.dart';

class AllPharmaciesPage extends StatelessWidget {
  const AllPharmaciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('build all pharmacies ===================');
    final cubit = BlocProvider.of<AllPharmaciesCubit>(context);
    return BlocListener<AllPharmaciesCubit, AllPharmaciesState>(
      listener: (context, state) {
        if (state is ErrorGetPharmaciesState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'error',
            desc: 'error while get data',
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('all pharmacies'),),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: mPadding),
          child: BlocBuilder<AllPharmaciesCubit, AllPharmaciesState>(
            builder: (context, state) {
              if (state is LoadedPharmaciesState) {
                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/logo2.png'),
                    ),
                    GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.pharmacies.length,
                      gridDelegate:
                          SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: MediaQuery.of(context).size.width <500 ? 1.7 : 1,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        maxCrossAxisExtent: 500,
                      ),
                      itemBuilder: (context, index) => SingleChildScrollView(
                        child: Stack(
                          alignment: AlignmentDirectional.topStart,
                          children: [
                            Opacity(
                              opacity: 0.9,
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(BlocProvider(
                                            create: (context) =>
                                                sl<AllEmployeesBloc>(),
                                            child: AllEmployeePage(
                                                pharmacyId:
                                                    state.pharmacies[index].id),
                                          )),
                                        );
                                      },
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            state.pharmacies[index].name,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26.0,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                state.pharmacies[index].region,
                                                style: const TextStyle(
                                                  fontSize: 22.0,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                state.pharmacies[index].city,
                                                style: const TextStyle(
                                                  fontSize: 22.0,
                                                ),
                                                // maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Text(
                                              // maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 22.0,
                                              ),
                                              state.pharmacies[index].street),
                                          Text(
                                              style: const TextStyle(
                                                fontSize: 22.0,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              state.pharmacies[index].phoneNumber
                                                  .toString()),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () => AwesomeDialog(
                                              context: context,
                                              body: const Text(
                                                  'are you sure from delete !?'),
                                              dialogType: DialogType.warning,
                                              btnOkOnPress: () =>
                                                  cubit.deletePharmacy(index),
                                              btnCancelOnPress: () {},
                                            ).show(),
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () => cubit.createOrUpdatePharmacy(
                                    context, state.pharmacies[index]),
                                icon: const Icon(Icons.edit)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              else if (state is ErrorGetPharmaciesState) {
                RefreshIndicator(
                  onRefresh: () async {
                    await cubit.getPharmacies();
                  },
                  child: const Center(
                    child: Text(
                      'error try again',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              else if (state is GetPharmaciesState) {
                return const Center(
                child: CircularProgressIndicator(),
              );
              }
              return Container();
            },
          ),
        ),
        floatingActionButton:  FloatingActionButton(
          onPressed: () async {
            cubit.createOrUpdatePharmacy(context, null);
          },
          tooltip: 'add pharmacy',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}