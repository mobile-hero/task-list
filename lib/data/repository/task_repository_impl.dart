import 'package:sqflite/sqflite.dart';
import 'package:task_list/data/model/task.dart';
import 'package:task_list/data/repository/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final Database db;

  TaskRepositoryImpl(this.db);

  @override
  Future<List<Task>> getTasks() async {
    final result = await db.query(
      TaskSql.tableName,
      where: '${TaskSql.deletedAt} IS NULL',
    );
    return result.map((e) => Task.fromJson(e)).toList();
  }

  @override
  Future<int> createTask(Task task) async {
    return db.insert(TaskSql.tableName, task.toJson());
  }

  @override
  Future<int> deleteTask(Task task) async {
    return db.delete(
      TaskSql.tableName,
      where: '${TaskSql.id} = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<int> updateTask(Task task) {
    return db.update(
      TaskSql.tableName,
      task.toJson(),
      where: "${TaskSql.id} = ?",
      whereArgs: [task.id],
    );
  }
}
