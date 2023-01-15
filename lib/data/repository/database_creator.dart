import 'package:sqflite/sqflite.dart';
import 'package:task_list/data/model/task.dart';

class DatabaseCreator {
  Database? database;

  void create() async {
    var db = await openDatabase(
      'task.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(TaskSql.queryCreateTable);
      },
    );
    database = db;
  }
}
