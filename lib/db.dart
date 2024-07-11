import 'package:flutter_lato/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'tasksv2.db'),
        onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE tasks (id INTEGER PRIMARY KEY, nombre TEXT, estado INTEGER, time TEXT)",
      );
    }, version: 1);
  }

  static Future<Future<int>> insert(Task task) async {
    Database database = await _openDB();

    return database.insert("tasks", task.toMap());
  }

  static Future<Future<int>> delete(Task task) async {
    Database database = await _openDB();

    return database.delete("tasks", where: "id = ?", whereArgs: [task.id]);
  }

  static Future<Future<int>> update(Task task) async {
    Database database = await _openDB();

    return database
        .update("tasks", task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  static Future<List<Task>> tasks() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> tasksMap = await database.query("tasks");

    return List.generate(
        tasksMap.length,
        (i) => Task(
            id: tasksMap[i]['id'],
            nombre: tasksMap[i]['nombre'],
            estado: tasksMap[i]['estado'],
            time: tasksMap[i]['time']));
  }

  // CON SENTENCIAS
  // static Future<void> insertar2(Task task) async {
  //   Database database = await _openDB();
  //   var resultado =
  //       await database.rawInsert("INSERT INTO tasks (id, nombre, estado)"
  //           " VALUES (${task.id}, ${task.nombre}, ${task.estado})");
  // }
}
