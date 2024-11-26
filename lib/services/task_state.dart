import 'package:flutter/material.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:todo_app/services/db_service.dart';

class TaskState extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;

  List<Tasks> _tasks = [];
  bool _isLoading = false;

  List<Tasks> get tasks => _tasks;
  bool get isLoading => _isLoading;

  TaskState() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _dbService.getTasks();

    _isLoading = false;
    notifyListeners();
  }

  // Reload tasks after adding
  Future<void> addTask(String content) async {
    await _dbService.addTask(content);
    await _loadTasks();
  }

  // Reload tasks after updating
  Future<void> updateTaskStatus(int id, int status) async {
    await _dbService.updateTaskStatus(id, status);
    await _loadTasks();
  }

  // Reload tasks after deleting
  Future<void> deleteTask(int id) async {
    await _dbService.deleteTask(id);
    await _loadTasks();
  }

  // Reload tasks after updating
  Future<void> updateTask(int id, String content) async {
    await _dbService.updateTaskContent(id, content);
    await _loadTasks();
  }

  // Reload tasks after clearing completed tasks
  Future<void> clearCompletedTasks() async{
    await _dbService.deleteCompletedTasks();
    await _loadTasks();
  }
}
