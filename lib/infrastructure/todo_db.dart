import 'package:sqflite/sqflite.dart';
import 'package:todo_sqflite/core/core.dart';
import 'package:todo_sqflite/domain/todo/todo_model.dart';

late Database _db;
Future<void> initializeDatabase() async {
  _db = await openDatabase(
    'todoDB',
    version: 1,
    onCreate: (db, version) async {
      db.execute(
          'CREATE TABLE todoTable (id INTEGER PRIMARY KEY, name TEXT, status TEXT )');
    },
  );
}

Future<void> loadDatabase() async {
  final result = await _db.rawQuery('SELECT * FROM todoTable');
  todoModelGlobalList.clear();
  for (var doc in result) {
    TodoModel t = TodoModel.fromMap(doc);
    todoModelGlobalList.add(t);
  }
}

Future<void> insertDatabase(TodoModel t) async {
  await _db.rawInsert('INSERT INTO todoTable(name,status) VALUES(?,?)',
      [t.todoName, t.todoStatus]);
  loadDatabase();
}

Future<void> deleteData(int id) async {
  await _db.rawUpdate('DELETE FROM todoTable WHERE id=?', [id]);
  await loadDatabase();
  print('Data deleted');
}

Future<void> updateData(int id, String name) async {
  await _db.rawUpdate('UPDATE todoTable SET name = ? WHERE id = ?', [name, id]);
  await loadDatabase();
  print('Data updated');
}

Future<void> changeStatus(int id, String oldStatus) async {
  String newStatus = oldStatus == '0' ? '1' : '0';
  await _db.rawUpdate(
      'UPDATE todoTable SET status = ? WHERE id = ?', [newStatus, id]);
  loadDatabase();
  print('Status Changed');
}
