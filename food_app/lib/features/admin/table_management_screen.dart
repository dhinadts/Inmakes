import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/models/table_info.dart';
import '../../services/table_service.dart';

final adminTableStreamProvider = StreamProvider<List<TableModel>>((ref) {
  return TableService().getTables();
});

class AdminTableManagementScreen extends ConsumerWidget {
  const AdminTableManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTables = ref.watch(adminTableStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Admin - Table Management")),
      body: asyncTables.when(
        data: (tables) => ListView.builder(
          itemCount: tables.length,
          itemBuilder: (context, index) {
            final table = tables[index];
            return Card(
              child: ListTile(
                title: Text("Table ${table.id} - Capacity: ${table.capacity}"),
                subtitle: Text(
                  "Status: ${table.status} | Booked by: ${table.bookedBy ?? "None"}",
                ),
                trailing: table.status == "booked"
                    ? ElevatedButton(
                        onPressed: () async {
                          await TableService().releaseTable(table.id);
                        },
                        child: const Text("Release"),
                      )
                    : const Text(
                        "Available",
                        style: TextStyle(color: Colors.green),
                      ),
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
