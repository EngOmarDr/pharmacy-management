// import 'package:flutter/material.dart';
// import 'package:pharmacy/features/pharmacy/domain/use_cases/all_pharmacies_use_case.dart';
// import 'package:pharmacy/injection_container.dart';
//
// class CreateMedicine extends StatefulWidget {
//   const CreateMedicine({Key? key}) : super(key: key);
//
//   @override
//   State<CreateMedicine> createState() => _CreateMedicineState();
// }
//
// class _CreateMedicineState extends State<CreateMedicine> {
//
//   List<dynamic> all = List.empty(growable: true);
//
//   get() async {
//     AllPharmaciesUseCase allPharmacies = sl();
//     await allPharmacies().then((value) {
//       value.fold((l) => debugPrint('fdsaf') , (r) => all = r);
//       print(all);
//     });
//   }
//
//   @override
//   void initState() {
//     get();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Medicine'),
//       ),
//       body: ListView.builder(
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text (all[index]['name']),
//             // tileColor: Colors.black,
//           );
//         },
//         itemCount: all.length,
//       ),
//     );
//   }
// }
