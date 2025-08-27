import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/table_provider.dart';
import '../models/table_info.dart';

// Main widget, now responsive
class TableGrid extends ConsumerWidget {
  final void Function(TableInfo table)? onSelect;
  final bool adminMode;

  const TableGrid({super.key, this.onSelect, this.adminMode = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tableProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the cross axis count based on device width
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = (screenWidth / 180)
            .floor(); // 180 is a good size for each card

        return GridView.builder(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: tables.length,
          itemBuilder: (context, i) {
            final table = tables[i];
            return _TableCard(
              table: table,
              onTap: () => onSelect?.call(table),
              adminMode: adminMode,
            );
          },
        );
      },
    );
  }
}

// Dedicated widget for a single table card
class _TableCard extends ConsumerWidget {
  final TableInfo table;
  final VoidCallback? onTap;
  final bool adminMode;

  const _TableCard({required this.table, this.onTap, required this.adminMode});

  Color _statusColor() {
    if (table.isOccupied) return Colors.red;
    if (table.isReserved) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the device's screen size
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circle avatar size adapts to screen size
              CircleAvatar(
                backgroundColor: _statusColor(),
                radius: screenWidth > 600 ? 24 : 18,
                child: Text(
                  table.number.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              // Text size adapts to screen size
              Text(
                'Cap: ${table.capacity}',
                style: TextStyle(fontSize: screenWidth > 600 ? 14 : 12),
              ),
              const SizedBox(height: 4),
              Text(
                table.isOccupied
                    ? 'Occupied'
                    : table.isReserved
                    ? 'Reserved'
                    : 'Free',
                style: TextStyle(
                  fontSize: screenWidth > 600 ? 14 : 12,
                  color: _statusColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (adminMode) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    OutlinedButton(
                      onPressed: () => ref
                          .read(tableProvider.notifier)
                          .toggleOccupied(table.number),
                      child: const Text('Toggle Occ'),
                    ),
                    OutlinedButton(
                      onPressed: () => ref
                          .read(tableProvider.notifier)
                          .toggleReserved(table.number),
                      child: const Text('Toggle Res'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
