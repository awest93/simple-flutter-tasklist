import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Список задач',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> tasks = [];
  final TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tasks = prefs.getStringList('tasks') ?? [];
    });
  }

  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();
      });
      saveTasks();
    }
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    saveTasks();
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список задач'),
        backgroundColor: Colors.blue
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]),
                  onTap: () {
                    taskController.text = tasks[index];
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Редактирование задачи'),
                          content: TextField(
                            controller: taskController,
                            decoration: InputDecoration(
                              labelText: 'Введите текст задачи',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  tasks[index] = taskController.text;
                                  taskController.clear();
                                });
                                saveTasks();
                                Navigator.of(context).pop();
                              },
                              child: Text('Сохранить'),
                            ),
                            TextButton(
                              onPressed: () {
                                taskController.clear();
                                Navigator.of(context).pop();
                              },
                              child: Text('Отменить'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTask(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Добавление задачи'),
                content: TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    labelText: 'Введите текст задачи',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        addTask();
                        taskController.clear();
                      });
                      saveTasks();
                      Navigator.of(context).pop();
                    },
                    child: Text('Сохранить'),
                  ),
                  TextButton(
                    onPressed: () {
                      taskController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Отменить'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}