part of 'task_bloc.dart';

@immutable
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {}

class TaskCreated extends TaskState {
  final int position;

  TaskCreated(this.position);
}

class TaskUpdated extends TaskState {
  final int position;

  TaskUpdated(this.position);
}

class TaskDeleted extends TaskState {
  final Task task;
  final int position;

  TaskDeleted(this.task, this.position);
}

class TaskOperationFailed extends TaskState {
  final String message;

  TaskOperationFailed(this.message);
}
