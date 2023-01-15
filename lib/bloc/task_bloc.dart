import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list/data/model/task.dart';
import 'package:task_list/data/repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;
  TaskBloc(this.taskRepository) : super(TaskInitial()) {
    on<GetTasksEvent>(_onGetTasksEvent);
    on<CreateTaskEvent>(_onCreateTaskEvent);
    on<SetTaskDoneEvent>(_onSetTaskDoneEvent);
    on<SetTaskUndoneEvent>(_onSetTaskUndoneEvent);
    on<DeleteTaskEvent>(_onDeleteTaskEvent);
    add(GetTasksEvent());
  }

  final List<Task> tasks = [];

  void _onGetTasksEvent(GetTasksEvent event, Emitter emit) async {
    final myTasks = await taskRepository.getTasks();
    tasks.clear();
    tasks.addAll(myTasks);
    emit(TaskLoaded());
  }

  void _onCreateTaskEvent(CreateTaskEvent event, Emitter emit) async {
    final newTask = Task.undone(event.text);
    final id = await taskRepository.createTask(newTask);
    newTask.id = id;
    tasks.add(newTask);
    emit(TaskCreated(tasks.length - 1));
  }
  
  void _onSetTaskDoneEvent(SetTaskDoneEvent event, Emitter emit) async {
    final task = event.task;
    task.isDone = true;
    final result = await taskRepository.updateTask(task);
    if (result > 0) {
      emit(TaskUpdated(event.position));
    } else {
      emit(TaskOperationFailed('Cannot update $task'));
    }
  }

  void _onSetTaskUndoneEvent(SetTaskUndoneEvent event, Emitter emit) async {
    final task = event.task;
    task.isDone = false;
    final result = await taskRepository.updateTask(task);
    if (result > 0) {
      emit(TaskUpdated(event.position));
    } else {
      emit(TaskOperationFailed('Cannot update $task'));
    }
  }

  void _onDeleteTaskEvent(DeleteTaskEvent event, Emitter emit) async {
    final task = event.task;
    final result = await taskRepository.deleteTask(task);
    tasks.remove(task);
    if (result > 0) {
      emit(TaskDeleted(task, event.position));
    } else {
      emit(TaskOperationFailed('Cannot update $task'));
    }
  }
}
