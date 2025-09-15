import 'package:flutter/foundation.dart';
import 'package:task_team/main.dart';

class Task {
  int id;
  String taskName;
  String? subTask;
  DateTime? updatedAt;
  bool isCompleted;
  Task({
    required this.taskName,
    this.updatedAt,
    this.subTask,
    this.isCompleted = false,
    required this.id,
  });
}

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> FillTasks() async {
    final user = supabase.auth.currentUser;

    // If no user is logged in, return early
    if (user == null) {
      print("No user logged in. Skipping FillTasks.");
      return;
    }

    print("Fetching tasks for user: ${user.id}");

    try {
      // Fetch tasks from Supabase
      final response = await supabase
          .from("tasks")
          .select()
          .eq('user_id', user.id);

      print("Fetched tasks: $response");

      // Clear old tasks before adding new ones
      _tasks.clear();

      // Convert each map to a Task object
      _tasks.addAll(
        response.map<Task>((task) {
          return Task(
            taskName: task["task_name"] ?? '',
            id: task["id"],
            subTask: task["sub_task"],
            updatedAt: DateTime.parse(task["updated_at"]),
            isCompleted: task["is_completed"] ?? false,
          );
        }).toList(),
      );

      // Notify listeners so UI rebuilds
      notifyListeners();

      print("Tasks updated. Total: ${_tasks.length}");
    } catch (error) {
      print("Error fetching tasks: $error");
    }
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void updateTask(String id, String newTitle, String newDescription) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.taskName = newTitle;
    task.subTask = newDescription;
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
