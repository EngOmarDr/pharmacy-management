// Row(
// children: [
// NavigationRail(
// destinations: HomePage.list,
// selectedIndex: sel,
// // extended: true,
// // leading: const Icon(Icons.leaderboard),
// // trailing: const Icon(Icons.train),
// // extended: true,
// useIndicator: true,
// labelType: NavigationRailLabelType.selected,
// onDestinationSelected: (value) {
// setState(() {
// sel = value;
// });
// },
// ),
// TweenAnimationBuilder(
// tween: Tween<double>(begin: 0, end: 1),
// duration: const Duration(milliseconds: 600),
// builder: (context, value, child) => Expanded(
// child: Transform.scale(
// scale: value,
// child: HomePage.wid[sel],
// ),
// ),
// ),
// ],
// ),