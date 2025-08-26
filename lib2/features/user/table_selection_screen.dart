
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/features/admin/booking_list_screen.dart';
import '../../widgets/table_grid.dart';
import '../../services/firebase_service.dart';
// import '../../core/providers.dart'; // in case you have a provider, fallback to direct instance otherwise

class TableSelectionScreen extends ConsumerStatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  ConsumerState<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends ConsumerState<TableSelectionScreen> {
  final TextEditingController _orderIdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final service = ref.read(firebaseServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Table')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _orderIdCtrl,
              decoration: const InputDecoration(
                labelText: 'Order ID to assign',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TableGrid(
                onSelect: (t) async {
                  if (_orderIdCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Enter an Order ID first')),
                    );
                    return;
                  }
                  await service.assignTableToOrder(_orderIdCtrl.text.trim(), t.number);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Assigned Table ${t.number} to Order ${_orderIdCtrl.text}')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
