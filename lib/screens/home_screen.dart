import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/services/task_state.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:todo_app/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskState = Provider.of<TaskState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do"),
        actions: [IconButton(onPressed: (){
          taskState.clearCompletedTasks();
        }, icon: const Icon(Icons.clear_all_rounded,color: white,))],
      ),
      floatingActionButton: _addTaskButton(context, taskState),
      body:
      SafeArea(child: taskState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _tasksList(taskState),
      ),
    );
  }

  // Add Task button
  Widget _addTaskButton(BuildContext context, TaskState taskState) {
    return FloatingActionButton(
      onPressed: () => _showAddTaskModal(context, taskState),
      child: const Icon(Icons.add),
    );
  }

  Future<void> _showAddTaskModal(BuildContext context, TaskState taskState) async {
    String? taskContent;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: fab,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: "Add Todo",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          taskContent = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            minimumSize: const Size(60,54)),
                        onPressed: () {
                          if (taskContent?.isEmpty ?? true) return;
                          taskState.addTask(taskContent!);
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.check),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // List of tasks
  Widget _tasksList(TaskState taskState) {
    if(taskState.tasks.isEmpty){
      return const Center(child: Text("Create a new Todo!", style: TextStyle(fontSize: 20)));
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: taskState.tasks.length,
      itemBuilder: (context, index) {
        final task = taskState.tasks[index];
        return Slidable(
          key: ValueKey(task.id),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (_) {
                  taskState.updateTaskStatus(task.id, task.status == 0 ? 1 : 0);
                },
                icon: Icons.check,
                backgroundColor: green,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            dismissible: DismissiblePane(
              onDismissed: () => taskState.deleteTask(task.id),
            ),
            children: [
              SlidableAction(
                onPressed: (_) {
                  _editTask(context, taskState, task);
                },
                icon: Icons.edit,
                backgroundColor: white,
              ),
              SlidableAction(
                onPressed: (_) => taskState.deleteTask(task.id),
                icon: Icons.delete_forever,
                backgroundColor: red,
              ),
            ],
          ),
          child: ListTile(
            minTileHeight: 60,
            title: Text(
              task.content,
              style: TextStyle(
                fontSize: 18,
                decoration: task.status == 1 ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      },
    );
  }

  // Edit Task functionality
  Future<void> _editTask(BuildContext context, TaskState taskState, Tasks task) async {
    String? updatedContent = task.content;
    TextEditingController controller = TextEditingController(text: task.content);

    await showModalBottomSheet(context: context, isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Edit Task",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          updatedContent = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            minimumSize: const Size(60,54)),
                        onPressed: () {
                          if (updatedContent?.isEmpty ?? true) return;
                          taskState.updateTask(task.id, updatedContent!);
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.check),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
