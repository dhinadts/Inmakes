
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/table_info.dart';

class TableController extends Notifier<List<TableInfo>> {
  @override
  List<TableInfo> build() {
    // Static tables (1..12)
    return List.generate(12, (i) => TableInfo(number: i+1, capacity: (i%4)+2));
  }

  void toggleOccupied(int tableNumber) {
    final idx = state.indexWhere((t) => t.number == tableNumber);
    if (idx != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx)
            TableInfo(
              number: state[i].number,
              capacity: state[i].capacity,
              isOccupied: !state[i].isOccupied,
              isReserved: state[i].isReserved,
            )
          else
            state[i]
      ];
    }
  }

  void toggleReserved(int tableNumber) {
    final idx = state.indexWhere((t) => t.number == tableNumber);
    if (idx != -1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx)
            TableInfo(
              number: state[i].number,
              capacity: state[i].capacity,
              isOccupied: state[i].isOccupied,
              isReserved: !state[i].isReserved,
            )
          else
            state[i]
      ];
    }
  }
}

final tableProvider = NotifierProvider<TableController, List<TableInfo>>(
  TableController.new,
);
