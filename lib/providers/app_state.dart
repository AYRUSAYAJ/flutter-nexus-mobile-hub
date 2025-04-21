
import 'package:flutter/material.dart';
import 'package:flutter_nexus_hub/models/task.dart';
import 'package:flutter_nexus_hub/utils/database_helper.dart';

class AppState extends ChangeNotifier {
  // Database tasks
  List<Task> _tasks = [];
  bool _isLoading = false;
  
  // Notification settings
  bool _notificationsEnabled = true;
  
  // Location data
  double _latitude = 0.0;
  double _longitude = 0.0;
  String _address = '';
  
  // RSS Feed data
  List<Map<String, dynamic>> _rssItems = [];
  
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get notificationsEnabled => _notificationsEnabled;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get address => _address;
  List<Map<String, dynamic>> get rssItems => _rssItems;
  
  // Database operations
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final dbHelper = DatabaseHelper.instance;
      final loadedTasks = await dbHelper.getTasks();
      _tasks = loadedTasks;
    } catch (e) {
      print('Error loading tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> addTask(String title, String description) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      completed: false,
    );
    
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.insertTask(task);
      await loadTasks(); // Reload tasks
    } catch (e) {
      print('Error adding task: $e');
    }
  }
  
  Future<void> toggleTaskCompletion(String id, bool isCompleted) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.updateTaskCompletion(id, isCompleted);
      await loadTasks(); // Reload tasks
    } catch (e) {
      print('Error toggling task completion: $e');
    }
  }
  
  Future<void> deleteTask(String id) async {
    try {
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.deleteTask(id);
      await loadTasks(); // Reload tasks
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
  
  // Notification settings
  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }
  
  // Location data
  void updateLocation(double latitude, double longitude, String address) {
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    notifyListeners();
  }
  
  // RSS Feed data
  void updateRssItems(List<Map<String, dynamic>> items) {
    _rssItems = items;
    notifyListeners();
  }
}
