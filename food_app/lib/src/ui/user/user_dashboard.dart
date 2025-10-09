import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers.dart';
import 'food_list_horizontal.dart';
import 'table_selection.dart';
import 'profile_screen.dart';

class UserDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text('User Dashboard')),
        body: TabBarView(children: [
          FoodListHorizontal(),
          TableSelection(),
          ProfileScreen(),
        ]),
        bottomNavigationBar: TabBar(tabs: [Tab(icon: Icon(Icons.fastfood), text: 'Menu'), Tab(icon: Icon(Icons.table_chart), text: 'Tables'), Tab(icon: Icon(Icons.person), text: 'Profile')], labelColor: Theme.of(context).primaryColor),
      ),
    );
  }
}
