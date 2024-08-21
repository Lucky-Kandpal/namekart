import 'package:flutter/material.dart';
import 'package:namekart/database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await _dbHelper.getTasks();
    notifyListeners();
  }

  Future<void> addTask(Map<String, dynamic> task) async {
    await _dbHelper.insertTask(task);
    await _loadTasks();
  }

  Future<void> updateTask(Map<String, dynamic> task) async {
    await _dbHelper.updateTask(task);
    await _loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    await _loadTasks();
  }
}
