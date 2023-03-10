import 'package:equatable/equatable.dart';

class Task extends Equatable {
  int? id;
  final String text;
  bool isDone;
  String? deletedAt;

  Task({this.id, required this.text, required this.isDone, this.deletedAt});

  factory Task.undone(String text) {
    return Task(text: text, isDone: false);
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json[TaskSql.id],
        text: json[TaskSql.text],
        isDone: json[TaskSql.isDone] == 1,
        deletedAt: json[TaskSql.deletedAt],
      );

  Map<String, dynamic> toJson() => {
        TaskSql.id: id,
        TaskSql.text: text,
        TaskSql.isDone: isDone ? 1 : 0,
        TaskSql.deletedAt: deletedAt,
      };

  @override
  List<Object> get props => [id ?? -1, text, isDone, deletedAt ?? ''];
}

class TaskSql {
  static const tableName = 'Task';
  static const queryCreateTable =
      'CREATE TABLE Task (id INTEGER PRIMARY KEY, text TEXT, is_done INTEGER, deleted_at TEXT)';

  static const id = 'id';
  static const text = 'text';
  static const isDone = 'is_done';
  static const deletedAt = 'deleted_at';
}
