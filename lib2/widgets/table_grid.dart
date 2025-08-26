
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/table_provider.dart';
import '../models/table_info.dart';

class TableGrid extends ConsumerWidget {
  final void Function(TableInfo table)? onSelect;
  final bool adminMode;
  const TableGrid({super.key, this.onSelect, this.adminMode = false});

  Color _statusColor(TableInfo t) {
    if (t.isOccupied) return Colors.red;
    if (t.isReserved) return Colors.orange;
    return Colors.green;
    }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tableProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tables.length,
      itemBuilder: (context, i) {
        final t = tables[i];
        return InkWell(
          onTap: () {
            if (onSelect != null) onSelect!(t);
          },
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: _statusColor(t),
                    radius: 18,
                    child: Text(t.number.toString(),
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  Text('Cap: ${t.capacity}',
                      style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    t.isOccupied
                        ? 'Occupied'
                        : t.isReserved
                            ? 'Reserved'
                            : 'Free',
                    style: TextStyle(
                      fontSize: 12,
                      color: _statusColor(t),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (adminMode) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        OutlinedButton(
                          onPressed: () =>
                              ref.read(tableProvider.notifier).toggleOccupied(t.number),
                          child: const Text('Toggle Occ'),
                        ),
                        OutlinedButton(
                          onPressed: () =>
                              ref.read(tableProvider.notifier).toggleReserved(t.number),
                          child: const Text('Toggle Res'),
                        ),
                      ],
                    ),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
