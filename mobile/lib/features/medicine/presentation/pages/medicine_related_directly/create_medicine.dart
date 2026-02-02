// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pharmacy/core/utils/my_text_field_widget.dart';
// import '../../../../../injection_container.dart';
// import '../../../../company/presentation/bloc/company_bloc.dart';
// import '../../../../company/presentation/pages/create_company.dart';
// import '../../bloc/create_medicine/add_medicine_bloc.dart';
// import 'package:searchfield/searchfield.dart';

// class AddMedicinePage extends StatelessWidget {
//   const AddMedicinePage({super.key});

//   static List<String> company = ['Ahmad', 'yazan', 'omar', 'mohamed'];

//   @override
//   Widget build(BuildContext context) {
//     print('========== Build Add Medicine ==========');
//     final bloc = BlocProvider.of<AddMedicineBloc>(context);
//     return Center(
//       child: Form(
//         key: bloc.formKey,
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//             MyTextField(
//               controller: bloc.name,
//               lText: 'Name',
//             ),
//             const SizedBox(height: 15),
//             Row(
//               children: [
//                 Expanded(
//                   child: MyTextField(
//                     controller: bloc.priceSale,
//                     keyType: TextInputType.number,
//                     validator: (p0) {
//                       switch (p0) {
//                         case null:
//                           return "can't be empty";
//                         case '':
//                           return "can't be empty";
//                       }
//                       return int.parse(p0) == 0 ? "can't be $p0" : null;
//                     },
//                     format: [FilteringTextInputFormatter.digitsOnly],
//                     lText: 'Price sale',
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: MyTextField(
//                     controller: bloc.pricePurchase,
//                     keyType: TextInputType.number,
//                     validator: (p0) {
//                       switch (p0) {
//                         case null:
//                           return "can't be empty";
//                         case '':
//                           return "can't be empty";
//                       }
//                       return int.parse(p0) == 0 ? "can't be $p0" : null;
//                     },
//                     format: [FilteringTextInputFormatter.digitsOnly],
//                     lText: 'Price purchase',
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: MyTextField(
//                     controller: bloc.quantity,
//                     keyType: TextInputType.number,
//                     validator: (p0) {
//                       switch (p0) {
//                         case null:
//                           return "can't be empty";
//                         case '':
//                           return "can't be empty";
//                       }
//                       return int.parse(p0) == 0 ? "can't be $p0" : null;
//                     },
//                     format: [FilteringTextInputFormatter.digitsOnly],
//                     lText: 'min Quantity',
//                   ),
//                 ),
//               ],
//             ),
//             // const SizedBox(height: 15),
//             // Row(
//             //   children: [
//             //     Expanded(
//             //       child: MyTextField(
//             //         keyType: TextInputType.datetime,
//             //         controller: bloc.expiryDate,
//             //         format: [
//             //           FilteringTextInputFormatter.digitsOnly,
//             //         ],
//             //         preIcon: IconButton(
//             //           onPressed: () {
//             //             bloc.add(InsertExpiryDateEvent(context));
//             //           },
//             //           icon: const Icon(
//             //             Icons.date_range,
//             //             color: Colors.black,
//             //           ),
//             //           padding: const EdgeInsets.symmetric(horizontal: 20),
//             //         ),
//             //         lText: 'Expiry Year',
//             //       ),
//             //     ),
//             //     const SizedBox(width: 15),
//             //     Expanded(
//             //       child: MyTextField(
//             //         keyType: TextInputType.datetime,
//             //         controller: bloc.expiryDateMonth,
//             //         validator: (p0) {
//             //           switch (p0) {
//             //             case null:
//             //               return "can't be empty";
//             //             case '':
//             //               return "can't be empty";
//             //           }
//             //           return int.parse(p0) <= 0 || int.parse(p0) > 12
//             //               ? "can't be $p0"
//             //               : null;
//             //         },
//             //         format: [
//             //           FilteringTextInputFormatter.digitsOnly,
//             //         ],
//             //         lText: 'Expiry Month',
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             const SizedBox(height: 15),
//             MyTextField(
//               keyType: TextInputType.number,
//               controller: bloc.barcode,
//               maxL: 13,
//               validator: bloc.barcodeValidator,
//               format: [FilteringTextInputFormatter.digitsOnly],
//               lText: 'Barcode',
//               preIcon: IconButton(
//                 onPressed: () {
//                   bloc.add(InsertBarcodeScannerEvent(context));
//                 },
//                 icon: const Icon(Icons.qr_code, color: Colors.black),
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//               ),
//             ),
//             //const SizedBox(height: 15),
//             SearchField<String>(
//               hint: 'company',
//               suggestions: company.map(
//                 (e) => SearchFieldListItem<String>(
//                   e,
//                   item: e,
//                   child: Padding(
//                     padding: const EdgeInsets.all(0),
//                     child: Row(
//                       children: [
//                         const Image(
//                             image: AssetImage('assets/images/companies.png')),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Text(e),
//                       ],
//                     ),
//                   ),
//                 ),
//               ).toList(),
//             ),
//         Align(
//           alignment: AlignmentDirectional.topStart,
//           child: TextButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => BlocProvider(
//                     create: (context) => sl<CompanyBloc>(),
//                     child: const CreateCompany(),
//                   ),
//                 );
//               },
//               child: const Text('create company')),),
//             const SizedBox(height: 15),
//             BlocBuilder<AddMedicineBloc, AddMedicineState>(
//               builder: (context, state) {
//                 return Container(
//                   color: Colors.green[100],
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton(
//                         style: const TextStyle(
//                             color: Colors.green, fontWeight: FontWeight.w900),
//                         dropdownColor: Colors.green[100],
//                         borderRadius: BorderRadius.circular(10),
//                         menuMaxHeight: 200,
//                         items: bloc.listItems,
//                         value: bloc.medicineType,
//                         onChanged: (newValue) {
//                           bloc.add(ChangeDropdownValueEvent(newValue));
//                         }),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 15),
//             BlocBuilder<AddMedicineBloc, AddMedicineState>(
//               builder: (context, state) {
//                 print('---------- Build Check Box ----------');
//                 return CheckboxListTile(
//                   controlAffinity: ListTileControlAffinity.leading,
//                   title: const Text('Need Prescription'),
//                   value: bloc.needPrescription,
//                   onChanged: (bool? value) =>
//                       bloc.add(ChangeCheckBoxEvent(value)),
//                 );
//               },
//             ),
//             const SizedBox(height: 15),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(double.infinity, 40)),
//               onPressed: () {
//                 bloc.add(SendDataEvent(context));
//               },
//               child: BlocBuilder<AddMedicineBloc, AddMedicineState>(
//                 buildWhen: (previous, current) {
//                   return current is StartSendDataState ||
//                       current is FinishSendDateState;
//                 },
//                 builder: (context, state) {
//                   print('---------- Build Child Elevated Button ----------');
//                   return state is StartSendDataState
//                       ? const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 3),
//                           child: CircularProgressIndicator(),
//                         )
//                       : const Text('submit');
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /*MyTextField(
//               controller: bloc.companyName,
//               lText: 'Company Name',
//             ),
//             Align(
//               alignment: AlignmentDirectional.topStart,
//               child: TextButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => BlocProvider(
//                         create: (context) => sl<CompanyBloc>(),
//                         child: const CreateCompany(),
//                       ),
//                     );
//                   },
//                   child: const Text('create company')),
//             ),*/