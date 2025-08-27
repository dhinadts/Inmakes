class TableInfo {
  final String id;
  final String name;
  final int seats;
  final bool available;
  final String? allocatedToOrderId;

  TableInfo({required this.id, required this.name, required this.seats, required this.available, this.allocatedToOrderId});

  factory TableInfo.fromMap(String id, Map<String, dynamic> m) {
    return TableInfo(
      id: id,
      name: m['name'] ?? '',
      seats: m['seats'] ?? 2,
      available: m['available'] ?? true,
      allocatedToOrderId: m['allocatedToOrderId'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'seats': seats,
    'available': available,
    'allocatedToOrderId': allocatedToOrderId,
  };
}
