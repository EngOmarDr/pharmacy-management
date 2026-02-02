import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dashboard/core/utils/my_text_field_widget.dart';
import 'package:dashboard/features/shift/presentation/bloc/create_update_cubit/create_or_update_shift_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/home_page.dart';

class CreateOrUpdateShiftPage extends StatelessWidget {
  const CreateOrUpdateShiftPage({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CreateOrUpdateShiftCubit>(context)
      ..getDetail(id);
    return BlocListener<CreateOrUpdateShiftCubit, CreateOrUpdateShiftState>(
      listener: (context, state) {
        if (state is ErrorCreateOrUpdateShiftState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'error',
            desc: state.message,
            btnOkOnPress: () {},
          ).show();
        } else if (state is CreateOrUpdateShiftSuccessState) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            title: 'success',
            body: Text(
                id == null ? 'create successfully' : 'updated successfully'),
            btnOkOnPress: () {
              Navigator.pop(context, true);
            },
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(id == null ? 'create Shift' : 'update shift').tr(),
        ),
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            const Opacity(
              opacity: 0.6,
              child: Image(
                image: AssetImage('assets/images/logo2.png'),
              ),
            ),
            Form(
              key: cubit.formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  shrinkWrap: true,
                    children: [
                  MyTextField(
                    controller: cubit.name,
                    lText: 'name'.tr(),
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: cubit.startTime,
                    lText: 'start time'.tr(),
                    hText: 'HH:MM',
                    keyType: TextInputType.datetime,
                    sufIcon: IconButton(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 12, minute: 00),
                          );
                          if (time != null) {
                            cubit.startTime.text =
                                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                          }
                        },
                        icon: const Icon(Icons.access_time)),
                    format: [
                      FilteringTextInputFormatter.allow(RegExp(r'^(?:[01]?\d|2[0-3])(?::(?:[0-5]\d?)?)?$')),
                    ],
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: cubit.endTime,
                    lText: 'end time'.tr(),
                    hText: 'HH:MM',
                    keyType: TextInputType.datetime,
                    sufIcon: IconButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 12, minute: 00),
                        );

                        if (time != null) {
                          cubit.endTime.text =
                              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        }
                      },
                      icon: const Icon(Icons.timelapse),
                    ),
                    format: [
                      FilteringTextInputFormatter.allow(RegExp(r'^(?:[01]?\d|2[0-3])(?::(?:[0-5]\d?)?)?$')),
                    ],
                  ),
                  Wrap(
                    children: List.generate(
                      cubit.dayWeek.length,
                      (index) => BlocBuilder<CreateOrUpdateShiftCubit,
                          CreateOrUpdateShiftState>(
                        buildWhen: (previous, current) {
                          return current is ChangeDayShiftState ||
                              current is LoadedDataShiftState;
                        },
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                            child: ChoiceChip(
                              backgroundColor: Colors.white54,
                              label: Text(DayWeek.values[index].nameEn),
                              selected: cubit.dayWeek[index],
                              onSelected: (value) {
                                cubit.changeDay(value, index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  FilledButton(onPressed: () {
                    cubit.createOrUpdateShift(id: id);
                  }, child: BlocBuilder<CreateOrUpdateShiftCubit,
                      CreateOrUpdateShiftState>(builder: (context, state) {
                    return state is LoadingDataShiftState
                        ? const CircularProgressIndicator()
                        : const Text('cr_submit').tr();
                  })),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
