import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

class QueryHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
      """CREATE TABLE note(id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT, 
      description TEXT,
      time TIMESTAMP DEFAULT CURRENT_TIMESTAMP)""",
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'note.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  static Future<int> insertNote(Map<String, Object> data) async {
    final db = await QueryHelper.db();
    return db.insert(
      'notes',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await QueryHelper.db();
    return db.query('notes');
  }

  static Future<int> updateNote(int id, Map<String, Object> data) async {
    final db = await QueryHelper.db();
    return db.update('notes', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteNote(int id) async {
    final db = await QueryHelper.db();
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteDatabase() async {
    final db = await QueryHelper.db();
    await db.close();
    await sql.deleteDatabase('note.db');
  }

  static Future<void> closeDatabase() async {
    final db = await QueryHelper.db();
    await db.close();
  }

  static Future<void> deleteTable() async {
    final db = await QueryHelper.db();
    await db.execute('DROP TABLE IF EXISTS notes');
  }

  static Future<void> deleteAllNotes() async {
    final db = await QueryHelper.db();
    await db.delete('notes');
  }

  static Future<void> deleteNoteById(int id) async {
    final db = await QueryHelper.db();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateNoteById(int id, Map<String, Object> data) async {
    final db = await QueryHelper.db();
    await db.update('notes', data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<Map<String, dynamic>> getNoteById(int id) async {
    final db = await QueryHelper.db();
    final List<Map<String, dynamic>> notes = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isNotEmpty) {
      return notes.first;
    } else {
      throw Exception('Note not found');
    }
  }

  static Future<void> deleteAllNotesByTitle(String title) async {
    final db = await QueryHelper.db();
    await db.delete('notes', where: 'title = ?', whereArgs: [title]);
  }

  static Future<List<Map<String, dynamic>>> getNotesByTitle(
    String title,
  ) async {
    final db = await QueryHelper.db();
    return db.query('notes', where: 'title = ?', whereArgs: [title]);
  }

  static Future<List<Map<String, dynamic>>> getNotesByDescription(
    String description,
  ) async {
    final db = await QueryHelper.db();
    return db.query(
      'notes',
      where: 'description = ?',
      whereArgs: [description],
    );
  }

  static Future<List<Map<String, dynamic>>> getNotesByTime(String time) async {
    final db = await QueryHelper.db();
    return db.query('notes', where: 'time = ?', whereArgs: [time]);
  }

  static Future<List<Map<String, dynamic>>> getNotesById(int id) async {
    final db = await QueryHelper.db();
    return db.query('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getNotesByTitleAndDescription(
    String title,
    String description,
  ) async {
    final db = await QueryHelper.db();
    return db.query(
      'notes',
      where: 'title = ? AND description = ?',
      whereArgs: [title, description],
    );
  }

  static Future<List<Map<String, dynamic>>> getNotesByTitleAndTime(
    String title,
    String time,
  ) async {
    final db = await QueryHelper.db();
    return db.query(
      'notes',
      where: 'title = ? AND time = ?',
      whereArgs: [title, time],
    );
  }

  static Future<int> getNoteCount() async {
    final db = await QueryHelper.db();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) FROM notes',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
