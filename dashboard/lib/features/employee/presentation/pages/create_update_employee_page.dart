import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dashboard/core/page_transition.dart';
import 'package:dashboard/core/utils/my_text_field_widget.dart';
import 'package:dashboard/features/employee/presentation/bloc/create_update_employee_cubit/create_or_update_employee_cubit.dart';
import 'package:dashboard/features/home/bloc/home_bloc.dart';
import 'package:dashboard/features/shift/presentation/pages/create_update_shift_page.dart';
import 'package:dashboard/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shift/domain/entities/shift.dart';
import '../../../shift/presentation/bloc/create_update_cubit/create_or_update_shift_cubit.dart';

class CreateOrUpdateEmployeePage extends StatelessWidget {
  const CreateOrUpdateEmployeePage(
      {Key? key, this.employeeId, required this.pharId})
      : super(key: key);

  final int? employeeId;
  final int pharId;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CreateOrUpdateEmployeeCubit>(context);

    print('object ---------------------=');
    return BlocListener<CreateOrUpdateEmployeeCubit,
        CreateOrUpdateEmployeeState>(
      listener: (context, state) {
        if (state is ErrorCreateOrUpdateEmployeeState) {
          AwesomeDialog(
            context: context,
            title: 'error',
            body: Text(state.error),
            dialogType: DialogType.error,
            animType: AnimType.scale,
            btnOkOnPress: () {},
          ).show();
        } else if (state is LoadedCreateEmployeeState) {
          AwesomeDialog(
            context: context,
            title: 'success',
            body: employeeId==null ? const Text('added success') : const Text('updated success') ,
            dialogType: DialogType.success,
            btnOkOnPress: () {
              Navigator.pop(context, true);
            },
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(employeeId == null
                ? 'create new employee'
                : 'update employee')),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            const Opacity(
              opacity: 0.6,
              child: SingleChildScrollView(
                child: Image(
                  image: AssetImage('assets/images/logo2.png'),
                ),
              ),
            ),
            BlocBuilder<CreateOrUpdateEmployeeCubit,
                CreateOrUpdateEmployeeState>(
              builder: (context, state) {
                if (state is LoadingShiftState ||
                    state is GetEmpDetailState ||
                    state is CreateOrUpdateEmployeeInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Form(
                    key: cubit.key,
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                                child: MyTextField(
                              controller: cubit.firstName,
                              lText: 'first name',
                            )),
                            const SizedBox(width: 15),
                            Expanded(
                                child: MyTextField(
                              controller: cubit.lastName,
                              lText: 'last name',
                            )),
                          ],
                        ),
                        const SizedBox(height: 15),
                        if (employeeId == null)
                          MyTextField(
                                  controller: cubit.email,
                                  lText: 'email',
                                  validator: (p0) {
                                    if (p0 == null) return "can't be empty";
                                    if (p0.trim().isEmpty) {
                                      return "can't be empty";
                                    }
                                    if (!p0.contains('@gmail.com') &&
                                        !p0.contains('@hotmail.com')) {
                                      return 'hotmail or gmail are allowed';
                                    }
                                    return null;
                                  },
                                  keyType: TextInputType.emailAddress)
                              .gap(),
                        if (employeeId == null)
                          BlocBuilder<CreateOrUpdateEmployeeCubit,
                              CreateOrUpdateEmployeeState>(
                            builder: (context, state) {
                              return MyTextField(
                                controller: cubit.pass,
                                obText: cubit.isObscure,
                                lText: 'password',
                                sufIcon: IconButton(
                                  onPressed: () {
                                    cubit.changeObscure();
                                  },
                                  icon: cubit.isObscure
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                ),
                              ).gap();
                            },
                          ),
                        if (employeeId == null)
                          MyTextField(
                            controller: cubit.rePass,
                            obText: true,
                            lText: 're password',
                          ).gap(),
                        MyTextField(
                            controller: cubit.phone,
                            lText: 'phone',
                            maxL: 10,
                            validator: (value) => value?.length != 10
                                ? 'phone number must be 10'
                                : null,
                            keyType: TextInputType.number,
                            format: [
                              FilteringTextInputFormatter.digitsOnly
                            ]).gap(),
                        MyTextField(
                            controller: cubit.salary,
                            lText: 'salary',
                            format: [
                              FilteringTextInputFormatter.digitsOnly
                            ]).gap(),
                        BlocBuilder<CreateOrUpdateEmployeeCubit,
                                CreateOrUpdateEmployeeState>(
                            buildWhen: (previous, current) {
                          return current is LoadingShiftState ||
                              previous is LoadingShiftState ||
                              current is GetEmpDetailState ||
                              previous is GetEmpDetailState;
                        }, builder: (context, state) {
                          if (state is LoadingDataShiftState ||
                              state is GetEmpDetailState ||
                              state is CreateOrUpdateEmployeeInitial) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if ((state is FinishEmpDetailState ||
                              state is LoadedShiftState)) {
                            return Autocomplete<(int, String)>(
                              initialValue:
                                  TextEditingValue(text: cubit.shift!),
                              fieldViewBuilder: (context, textEditingController,
                                      focusNode, onFieldSubmitted) =>
                                  MyTextField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                fieldSubmit: (String value) {
                                  onFieldSubmitted();
                                },
                              ),
                              displayStringForOption: (option) {
                                return '${option.$1}- ${option.$2}';
                              },
                              optionsViewBuilder:
                                  (context, onSelected, options) => Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  color: Colors.green[100],
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 200,
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                40),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (_, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  color: Colors.green),
                                            ),
                                            onTap: () {
                                              onSelected(
                                                  options.toList()[index]);
                                            },
                                            title: Text(
                                                options.toList()[index].$2,
                                                style: const TextStyle(
                                                    color: Colors.black)),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              optionsBuilder: (textEditingValue) async {
                                return cubit.listShift.where((element) =>
                                    element.$2.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase()));
                              },
                              onSelected: (option) {
                                cubit.shiftId = option.$1;
                              },
                            );
                          } else {
                            return Text('$state');
                          }
                        }),
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: TextButton(
                            onPressed: () async {
                              final dynamic res = await Navigator.push(
                                  context,
                                  PageTransition(BlocProvider(
                                    create: (context) =>
                                        sl<CreateOrUpdateShiftCubit>(),
                                    child: const CreateOrUpdateShiftPage(),
                                  )));
                              if (res) cubit.getShift();
                            },
                            child: const Text(
                              'create shift',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        if (employeeId != null)
                          CheckboxListTile(
                            value: cubit.isActive,
                            onChanged: (value) {
                              cubit.changeActive(value!);
                            },
                            title: const Text('is active',
                                style: TextStyle(color: Colors.deepOrange)),
                          ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Text('Role',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                                BlocBuilder<CreateOrUpdateEmployeeCubit,
                                    CreateOrUpdateEmployeeState>(
                                  buildWhen: (previous, current) {
                                    return current is ChangeRadioState ||
                                        current is FinishEmpDetailState;
                                  },
                                  builder: (context, state) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          HomeBloc.loginModel!.type == 'M'
                                              ? 5
                                              : 3,
                                      itemBuilder: (context, index) =>
                                          RadioListTile(
                                        selected: cubit.role ==
                                            Role.values[index].value,
                                        selectedTileColor: Colors.green[50],
                                        title: Text(Role.values[index].name),
                                        value: Role.values[index].value,
                                        groupValue: cubit.role,
                                        onChanged: (value) => cubit.changeRadio(
                                            value as String, index),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        FilledButton(
                          onPressed: () async {
                            await cubit.createEmployee();
                          },
                          child: BlocBuilder<CreateOrUpdateEmployeeCubit,
                              CreateOrUpdateEmployeeState>(
                            buildWhen: (previous, current) {
                              return current is LoadingCreateEmployeeState ||
                                  previous is LoadingCreateEmployeeState;
                            },
                            builder: (context, state) {
                              return state is LoadingCreateEmployeeState
                                  ? const CircularProgressIndicator()
                                  : const Text('submit');
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
