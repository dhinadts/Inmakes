
import 'package:flutter/material.dart';
import '../../widgets/table_grid.dart';

class TableManagementScreen extends StatelessWidget {
  const TableManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tables (Admin)')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TableGrid(adminMode: true),
      ),
    );
  }
}
