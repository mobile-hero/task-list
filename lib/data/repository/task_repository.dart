import 'package:task_list/data/model/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<int> createTask(Task task);

  Future<int> updateTask(Task task);

  Future<int> deleteTask(Task task);
}
