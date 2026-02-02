import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/constant.dart';
import 'package:pharmacy/features/medicine/presentation/widgets/widgets.dart';
import '../../bloc/sale_medicine/sale_medicine_bloc.dart';

class SaleMedicinePage extends StatelessWidget {
  const SaleMedicinePage({Key? key, required this.type}) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SaleMedicineBloc>(context)
      ..add(InitialEvent());
    return Scaffold(
      body: SingleChildScrollView(
        reverse: true,
        child: Form(
          key: bloc.formKey,
          child: Column(
            children: [
              BuildCardMedicine(bloc: bloc),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: BlocBuilder<SaleMedicineBloc, SaleMedicineState>(
                  builder: (context, state) {
                    return DataTable(
                      showCheckboxColumn: true,
                      columnSpacing: 30,
                      columns: const [
                        DataColumn(label: Text('name')),
                        DataColumn(label: Text('quantity'), numeric: true),
                        DataColumn(label: Text('price'), numeric: true),
                      ],
                      rows: List.generate(
                        bloc.listMed.length,
                        (index) => DataRow(
                          onSelectChanged: (value) async{
                            value!
                                ? await myAwesomeDlg(
                                    context: context,
                                    message: 'message',
                                    title: 'title',
                                    type: DialogType.warning)
                                : null;
                          },
                          cells: [
                            DataCell(Text(bloc.listMed[index].name)),
                            DataCell(Text('${bloc.listMed[index].qty}')),
                            DataCell(Text('${bloc.listMed[index].price}')),
                          ],
                        ),
                      ),
                      showBottomBorder: true,
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              FilledButton(
                onPressed: () => bloc.add(SendDataEvent(context)),
                child: BlocBuilder<SaleMedicineBloc, SaleMedicineState>(
                    buildWhen: (previous, current) =>
                        current is StartSendDataState ||
                        current is EndSendDataState,
                    builder: (context, state) => state is StartSendDataState
                        ? const Padding(
                            padding: EdgeInsets.all(3),
                            child: CircularProgressIndicator(),
                          )
                        : const Text('submit')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// old design
//BlocBuilder<SaleMedicineBloc, SaleMedicineState>(
//               builder: (context, state) {
//                 return ListView.separated(
//                   physics: const NeverScrollableScrollPhysics(),
//                   separatorBuilder: (context, index) =>
//                       const SizedBox(height: 15),
//                   itemBuilder: (context, i) => BuildCardMedicine(
//                     price: bloc.price[i],
//                     quantity: bloc.quantity[i],
//                     bloc: bloc,
//                     index: i,
//                   ),
//                   shrinkWrap: true,
//                   itemCount: bloc.price.length,
//                 );
//               },
//             ),
//             const SizedBox(height: 15),
//             Column(
//               children: [
//                 FilledButton(
//                   onPressed: () {
//                     bloc.add(AddMedicineForSale());
//                   },
//                   child: const Icon(Icons.add),
//                 ),
//                 const SizedBox(height: 15),
//                 FilledButton(
//                   onPressed: () => bloc.add(SendDataEvent(context)),
//                   child: BlocBuilder<SaleMedicineBloc, SaleMedicineState>(
//                       buildWhen: (previous, current) =>
//                           current is StartSendDataState ||
//                           current is EndSendDataState,
//                       builder: (context, state) => state is StartSendDataState
//                           ? const Padding(
//                               padding: EdgeInsets.all(3),
//                               child: CircularProgressIndicator(),
//                             )
//                           : const Text('submit')),
//                 ),
//               ],
//             ),
