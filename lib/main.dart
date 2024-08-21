import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:namekart/state_management.dart';
import 'package:namekart/task_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NameKart',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NameKart To-Do List'),
        backgroundColor: const Color(0xffF4C2C2),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(task['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(task['deadline']),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => taskProvider.deleteTask(task['id']),
              ),
              onTap: () => _navigateToTaskScreen(context, task),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF4C2C2),
        child: const Icon(Icons.add),
        onPressed: () => _navigateToTaskScreen(context),
      ),
    );
  }

  Future<void> _navigateToTaskScreen(BuildContext context,
      [Map<String, dynamic>? task]) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TaskScreen(task: task),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
