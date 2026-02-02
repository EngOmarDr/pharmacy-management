import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmacy/core/page_transition.dart';
import 'package:pharmacy/features/auth/data/dataSources/auth_local_source.dart';
import 'package:pharmacy/features/auth/data/models/login_model.dart';
import 'package:pharmacy/features/auth/presentation/pages/login_page.dart';
import 'package:pharmacy/features/company/presentation/bloc/company_bloc.dart';
import 'package:pharmacy/features/company/presentation/pages/all_companies.dart';
import 'package:pharmacy/pages/home/bloc/home_bloc.dart';
import 'package:pharmacy/pages/home/dispose/pages/dispose_add_page.dart';
import 'package:pharmacy/pages/home/dispose/pages/dispose_list_page.dart';
import 'package:pharmacy/pages/home/equals/add_equals_page.dart';
import 'package:pharmacy/pages/home/equals/cubit/equals_cubit.dart';
import 'package:pharmacy/pages/home/equals/show_equals_page.dart';
import 'package:pharmacy/pages/home/inventory/cubit/inventory_cubit.dart';
import 'package:pharmacy/pages/home/inventory/inventory_list_page.dart';
import 'package:pharmacy/pages/home/medicine/list_medicine_page.dart';
import 'package:pharmacy/pages/home/notifiaction_page.dart';
import 'package:pharmacy/pages/home/purchase/purchase_add_page.dart';
import 'package:pharmacy/pages/home/purchase/purchase_list_page.dart';
import 'package:pharmacy/pages/home/retrive/retrieve_add_page.dart';
import 'package:pharmacy/pages/home/retrive/retrieve_list_page.dart';
import 'package:pharmacy/pages/home/sale/sales_add_page.dart';
import 'package:pharmacy/pages/home/sale/sales_list_page.dart';

import '../../features/auth/presentation/bloc/login_bloc.dart';
import '../../features/medicine/presentation/bloc/create_medicine/add_medicine_bloc.dart';
import '../../injection_container.dart';
import 'medicine/create_medicine_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.loginModel}) : super(key: key);

  final LoginModel loginModel;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        print('=============== build Home Page ===============');
        return Scaffold(
          appBar: AppBar(
              title: [
            const Text('purchase medicine'),
            const Text('sale medicine')
          ][bloc.indexNavBar]),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: IndexedStack(
              index: bloc.indexNavBar,
              children: [
                PurchaseAddPage(loginModel: loginModel),
                SalesAddPage(loginModel: loginModel),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                if (loginModel.type == 'M')
                  ListTile(
                    title: const Text('create medicine'),
                    onTap: () =>
                        Navigator.of(context).push(PageTransition(BlocProvider(
                      create: (_) => sl<AddMedicineBloc>(),
                      child: AddMedicinePage(loginModel: loginModel),
                    ))),
                  ),
                ListTile(
                  title: const Text('medicines list'),
                  onTap: () => Navigator.of(context).push(
                      PageTransition(MedicineListPage(loginModel: loginModel))),
                ),
                const Divider(),
                ListTile(
                  title: const Text('companies list'),
                  onTap: () => Navigator.of(context).push(PageTransition(
                    BlocProvider(
                      create: (context) => sl<CompanyBloc>(),
                      child: const AllCompany(),
                    ),
                  )),
                ),
                ListTile(
                  title: const Text('inventory list'),
                  onTap: () async {
                    Navigator.of(context).push(
                      PageTransition(
                        BlocProvider(
                          create: (_) => InventoryCubit(),
                          child: InventoryListPage(loginModel: loginModel),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('purchase list'),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PurchaseListPage(loginModel: loginModel)),
                    );
                  },
                ),
                ListTile(
                  title: const Text('sales list'),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SalesListPage(loginModel: loginModel)),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('dispose list'),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DisposeListPage(loginModel: loginModel)),
                    );
                  },
                ),
                ListTile(
                  title: const Text('dispose add'),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DisposeAddPage(loginModel: loginModel)),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('retrieve list'),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RetrieveListPage(loginModel: loginModel)),
                    );
                  },
                ),
                ListTile(
                  title: const Text('retrieve add'),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              RetrieveAddPage(loginModel: loginModel)),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('add equals'),
                  onTap: () async {
                    Navigator.of(context).push(
                      PageTransition(
                        BlocProvider(
                          create: (_) => EqualsCubit(),
                          child: AddEqualsPage(loginModel: loginModel),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text('show equals'),
                  onTap: () async {
                    await Navigator.of(context).push(PageTransition(
                      BlocProvider(
                        create: (_) => EqualsCubit(),
                        child: ShowEqualsPage(
                            accessToken: loginModel.tokens.access),
                      ),
                    ));
                  },
                ),
                if (loginModel.type.toUpperCase() == 'M' ||
                    loginModel.type.toUpperCase() == 'PM')
                  ListTile(
                    title: const Text('notification'),
                    trailing: const Icon(Icons.notifications_active_outlined),
                    onTap: () async {
                      Navigator.of(context)
                          .push(PageTransition(NotificationPage(
                        pharmacyId: loginModel.pharmacyId ?? 1,
                        token: loginModel.tokens.access,
                      )));
                    },
                  ),
                const Divider(),
                ListTile(
                  title: const Text('logout'),
                  onTap: () async {
                    await sl<AuthLocalSource>().deleteAuthData().then((value) {
                      Navigator.of(context).pushReplacement(PageTransition(
                        BlocProvider(
                          create: (context) => sl<LoginBloc>(),
                          child: const LoginPage(),
                        ),
                      ));
                    });
                  },
                  trailing: const Icon(Icons.logout),
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.add_shopping_cart), label: 'add'),
              NavigationDestination(
                  icon: Icon(Icons.sell_outlined), label: 'sale'),
            ],
            onDestinationSelected: (index) =>
                bloc.add(ChangeNavigationBarEvent(index)),
            selectedIndex: bloc.indexNavBar,
            animationDuration: const Duration(milliseconds: 700),
          ),
        );
      },
    );
  }
}
