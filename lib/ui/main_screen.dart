import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_list/bloc/task_bloc.dart';
import 'package:task_list/data/model/task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskLoaded) {
            for (int i = 0; i < bloc.tasks.length; i++) {
              _listKey.currentState?.insertItem(i);
            }
          } else if (state is TaskCreated) {
            _listKey.currentState?.insertItem(state.position);
          } else if (state is TaskUpdated) {
            _listKey.currentState?.setState(() {});
          } else if (state is TaskDeleted) {
            _listKey.currentState?.removeItem(
              state.position,
              (context, animation) =>
                  _removeItemBuilder(state.task, context, animation),
            );
          }
        },
        builder: (context, state) {
          return AnimatedList(
            key: _listKey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            initialItemCount: bloc.tasks.length,
            itemBuilder: (context, position, animation) {
              final item = bloc.tasks[position];
              return SizeTransition(
                sizeFactor: animation,
                child: ListTile(
                  leading: Container(
                    height: 48,
                    width: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade900,
                    ),
                    child: Text(
                      item.text[0].toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  title: Text(
                    item.text,
                    style: TextStyle(
                        decoration:
                            item.isDone ? TextDecoration.lineThrough : null),
                  ),
                  trailing: item.isDone ? IconButton(
                    onPressed: () {
                      bloc.add(DeleteTaskEvent(item, position));
                    },
                    icon: const Icon(Icons.delete),
                  ) : null,
                  onTap: () {
                    bloc.add(item.isDone
                        ? SetTaskUndoneEvent(item, position)
                        : SetTaskDoneEvent(item, position));
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateTaskDialog(context, bloc),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _removeItemBuilder(
      Task task, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        leading: Container(
          height: 48,
          width: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade900,
          ),
          child: Text(
            task.text[0].toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          task.text,
          style: TextStyle(
              decoration: task.isDone ? TextDecoration.lineThrough : null),
        ),
      ),
    );
  }

  void showCreateTaskDialog(BuildContext context, TaskBloc taskBloc) async {
    final TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a new todo item'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Type your new todo'),
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  taskBloc.add(CreateTaskEvent(controller.text));
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
  }
}
