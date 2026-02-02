// import 'package:dashboard/core/page_transition.dart';
// import 'package:dashboard/features/auth/data/dataSources/auth_local_source.dart';
// import 'package:dashboard/features/auth/presentation/pages/login_page.dart';
// import 'package:dashboard/features/home/bloc/home_bloc.dart';
// import 'package:dashboard/injection_container.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// class DrawerMenu extends StatelessWidget {
//   const DrawerMenu({Key? key, required this.type, required this.bloc})
//       : super(key: key);
//
//   final String type;
//   final HomeBloc bloc;
//
//   @override
//   Widget build(BuildContext context) {
//     var brightness = MediaQuery.of(context).platformBrightness;
//     return Drawer(
//       shape: const RoundedRectangleBorder(),
//       child: Column(
//         children: [
//           // Container(
//           //   padding: const EdgeInsets.all(20),
//           // child: Image.asset("assets/images/logowithtext.png"),
//           // ),
//           if (type == 'M') ...[
//             ListView.builder(
//               shrinkWrap: true,
//               itemCount: 2,
//               itemBuilder: (context, index) => ListTile(
//                 onTap: () {
//                   bloc.add(
//                       ChangeHomeWidgetEvent(context, index: index, type: type));
//                   Navigator.pop(context);
//                 },
//                 selectedTileColor: Colors.green[100],
//                 selected: bloc.isSel[index],
//                 // leading: SvgPicture.asset(svgSrc,color: grey,height: 20,),
//                 title: Text(bloc.titleList[index]),
//               ),
//             ),
//             const Divider(
//               color: Colors.grey,
//               indent: 15,
//               endIndent: 15,
//             ),
//           ],
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: 3,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 onTap: () {
//                   bloc.add(ChangeHomeWidgetEvent(context,
//                       index: index + 2, type: type));
//                   Navigator.pop(context);
//                 },
//                 selectedTileColor: Colors.green.shade100,
//                 selected: bloc.isSel[index + 2],
//                 // leading: SvgPicture.asset(svgSrc,color: grey,height: 20,),
//                 title: Text(bloc.titleList[index + 2]),
//               );
//             },
//           ),
//           const Divider(
//             color: Colors.grey,
//             indent: 15,
//             endIndent: 15,
//           ),
//
//           SwitchListTile(
//               value: brightness == Brightness.light,
//               onChanged: (value) {
//                 if (value) {}
//               },
//               title: const Text('theme')),
//           SwitchListTile(
//               value: context.locale.languageCode == 'en',
//               onChanged: (value) {
//                 if (value) {
//                   context.setLocale(const Locale('en'));
//                 } else {
//                   context.setLocale(const Locale('ar'));
//                 }
//               },
//               title: const Text('language')),
//           ListTile(
//             onTap: () async {
//               final authLocal = AuthLocalSourceImpl1(secureStorage: sl());
//               await authLocal.deleteAuthData().then((value) async {
//                 Navigator.pushReplacement(
//                     context, PageTransition(const LoginPage()));
//               });
//               await bloc.close();
//             },
//             selectedTileColor: Colors.green.shade100,
//             selected: bloc.isSel[5],
//             // leading: SvgPicture.asset(svgSrc,color: grey,height: 20,),
//             title: const Text('logout'),
//           ),
//         ],
//       ),
//     );
//   }
// }
