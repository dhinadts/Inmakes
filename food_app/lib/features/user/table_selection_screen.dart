import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/models/table_info.dart';
import 'package:food_app/services/table_service.dart';
// import '../../models/table_model.dart';
// import '../../services/table_service.dart';

final tableStreamProvider = StreamProvider<List<TableModel>>((ref) {
  return TableService().getTables();
});

class TableSelectionScreen extends ConsumerWidget {
  const TableSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTables = ref.watch(tableStreamProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Choose Table")),
      body: asyncTables.when(
        data: (tables) => ListView.builder(
          itemCount: tables.length,
          itemBuilder: (context, index) {
            final table = tables[index];
            return Card(
              child: ListTile(
                title: Text("Table ${table.id} - Capacity: ${table.capacity}"),
                subtitle: Text("Status: ${table.status}"),
                trailing: table.status == "available"
                    ? ElevatedButton(
                        onPressed: () async {
                          await TableService().bookTable(table.id, userId);
                        },
                        child: const Text("Book"),
                      )
                    : Text("Booked", style: TextStyle(color: Colors.red)),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
