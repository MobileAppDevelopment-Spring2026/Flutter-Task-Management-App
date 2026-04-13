import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class SubTask {
  String time;
  String taskDetails;

  SubTask({required this.time, required this.taskDetails});
}

class Task {
  String name;
  bool isCompleted;
  List<SubTask> subTasks;

  Task({required this.name, this.isCompleted = false, required this.subTasks});
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  TextEditingController _taskController = TextEditingController();

  void addTask(String taskName) {
    setState(() {
      tasks.add(Task(name: taskName, subTasks: []));
    });
  }

  void completeTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void addSubTask(int index, SubTask subTask) {
    setState(() {
      tasks[index].subTasks.add(subTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management App'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Add new task',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    String taskName = _taskController.text.trim();
                    if (taskName.isNotEmpty) {
                      addTask(taskName);
                      _taskController.clear();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      leading: Checkbox(
                        value: tasks[index].isCompleted,
                        onChanged: (bool? value) {
                          completeTask(index);
                        },
                      ),
                      title: Text(
                        tasks[index].name,
                        style: tasks[index].isCompleted
                            ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                        )
                            : TextStyle(), // Apply strikethrough style when completed
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteTask(index);
                        },
                      ),
                    ),
                    if (tasks[index].subTasks.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tasks[index]
                              .subTasks
                              .map((subTask) => Text(
                            '${subTask.time}: ${subTask.taskDetails}',
                          ))
                              .toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
