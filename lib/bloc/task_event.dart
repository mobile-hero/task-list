part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class GetTasksEvent extends TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final String text;

  CreateTaskEvent(this.text);
}

class SetTaskDoneEvent extends TaskEvent {
  final Task task;
  final int position;

  SetTaskDoneEvent(this.task, this.position);
}

class SetTaskUndoneEvent extends TaskEvent {
  final Task task;
  final int position;

  SetTaskUndoneEvent(this.task, this.position);
}

class DeleteTaskEvent extends TaskEvent {
  final Task task;
  final int position;

  DeleteTaskEvent(this.task, this.position);
}

