import 'package:flutter/material.dart';
import 'manage_orders_screen.dart';
import 'add_food_screen.dart';
import 'table_allocation_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text('Admin Panel')),
        body: TabBarView(children: [ManageOrdersScreen(), TableAllocationScreen(), AddFoodScreen()]),
        bottomNavigationBar: TabBar(tabs: [Tab(icon: Icon(Icons.list), text: 'Orders'), Tab(icon: Icon(Icons.table_bar), text: 'Tables'), Tab(icon: Icon(Icons.add), text: 'Add Food')], labelColor: Theme.of(context).primaryColor),
      ),
    );
  }
}
