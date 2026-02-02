import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dashboard/features/shift/presentation/bloc/all_shift_cubit/all_shift_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllShiftPage extends StatelessWidget {
  const AllShiftPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AllShiftCubit>(context);
    return BlocListener<AllShiftCubit, AllShiftState>(
      listener: (context, state) {
        if (state is ErrorShiftState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'error',
            desc: state.errorMessage,
            btnOkOnPress: () {},
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('all shift'),
        ),
        body: Stack(
          children: [
            const Opacity(
              opacity: 0.6,
              child: Center(
                child: Image(
                  image: AssetImage('assets/images/logo2.png'),
                ),
              ),
            ),
            BlocBuilder<AllShiftCubit, AllShiftState>(
              builder: (context, state) {
                if (state is LoadedAllShiftState) {
                  return state.allShift.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            cubit.getAllShift();
                          },
                          child: AnimatedList(
                            key: cubit.listKey,
                            shrinkWrap: true,
                            initialItemCount: state.allShift.length,
                            padding: const EdgeInsets.all(15),
                            itemBuilder: (context, index, animation) {
                              return SlideTransition(
                                position: animation.drive(Tween<Offset>(
                                    begin: const Offset(-1, 0),
                                    end: const Offset(0, 0))),
                                child: shiftItem(
                                    cubit, state, index, context),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text("you don't have employee yet"));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            cubit.createOrUpdateShift(context);
          },
          tooltip: 'add shift',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

Widget shiftItem(AllShiftCubit cubit,LoadedAllShiftState state, int index,
    BuildContext context) {
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
                        cubit.deleteShift(state.allShift[index].$1,state.allShift,index);
                      },
                      icon: const Icon(Icons.delete)),
                  IconButton.outlined(
                      onPressed: () {
                        cubit.createOrUpdateShift(context,
                            id: state.allShift[index].$1);
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ),
            title: Text(state.allShift[index].$2)),
      ),
    ),
  );
}

//ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: state.allShift.length,
//                             padding: const EdgeInsets.all(15),
//                             itemBuilder: (context, index) {
//                               return TweenAnimationBuilder(
//                                   tween: Tween<double>(begin: 0, end: 1),
//                                   duration: const Duration(milliseconds: 600),
//                                   curve: Curves.easeInOut,
//                                   builder: (context, value, child) {
//                                     return Transform.scale(
//                                       scale: value,
//                                       child: GestureDetector(
//                                         onTap: () {},
//                                         child: Card(
//                                           margin: const EdgeInsets.symmetric(
//                                               vertical: 7),
//                                           elevation: 10,
//                                           child: Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 15),
//                                             child: ListTile(
//                                                 trailing: FittedBox(
//                                                   child: Row(
//                                                     children: [
//                                                       IconButton(
//                                                           onPressed: () {
//                                                             cubit.deleteShift(
//                                                                 state
//                                                                     .allShift[
//                                                                         index]
//                                                                     .$1);
//                                                           },
//                                                           icon: const Icon(
//                                                               Icons.delete)),
//                                                       IconButton.outlined(
//                                                           onPressed: () {
//                                                             cubit.createOrUpdateShift(
//                                                                 context,
//                                                                 id: state
//                                                                     .allShift[
//                                                                         index]
//                                                                     .$1);
//                                                           },
//                                                           icon: const Icon(
//                                                               Icons.edit)),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 title: Text(
//                                                     state.allShift[index].$2)),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   });
//                             },
//                           ),
