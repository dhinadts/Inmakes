
class TableInfo {
  final int number;
  final int capacity;
  bool isOccupied;
  bool isReserved;

  TableInfo({
    required this.number,
    required this.capacity,
    this.isOccupied = false,
    this.isReserved = false,
  });
}
