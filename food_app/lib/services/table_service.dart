import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/models/table_info.dart';

class TableService {
  final CollectionReference tablesRef = FirebaseFirestore.instance.collection(
    "tables",
  );

  /// 🔥 Live stream of all tables (updates instantly like StreamBuilder)
  Stream<List<TableModel>> getTables() {
    return tablesRef.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                TableModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList(),
    );
  }

  /// 📌 Book a table
  Future<void> bookTable(String tableId, String userId) async {
    await tablesRef.doc(tableId).update({
      "status": "booked",
      "bookedBy": userId,
      "bookedAt": FieldValue.serverTimestamp(),
    });
  }

  /// 📌 Release a table
  Future<void> releaseTable(String tableId) async {
    await tablesRef.doc(tableId).update({
      "status": "available",
      "bookedBy": null,
      "bookedAt": null,
    });
  }

  /// 📌 Create default static tables if none exist
  Future<void> createDefaultTables() async {
    final snapshot = await tablesRef.get();

    if (snapshot.docs.isEmpty) {
      final defaultTables = [
        TableModel(id: "T1", capacity: 2),
        TableModel(id: "T2", capacity: 4),
        TableModel(id: "T3", capacity: 6),
        TableModel(id: "T4", capacity: 8),
      ];

      for (var table in defaultTables) {
        await tablesRef.doc(table.id).set(table.toMap());
      }
    }
  }
}
