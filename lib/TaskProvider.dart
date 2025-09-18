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
  final List<Task> _shared_tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get sharedTasks => List.unmodifiable(_shared_tasks);

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
          print(task["id"]);
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

  void OrgaddTask(Task task) {
    _shared_tasks.add(task);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskCompletion(int id) {
    print(id);
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

  void cleartasks() {
    _tasks.clear();
    _shared_tasks.clear();
  }

  Future<void> AddingOrgaTasks() async {
    print("🔹 AddingOrgaTasks started...");

    final user = supabase.auth.currentUser;
    if (user == null) {
      print("❌ No authenticated user found!");
      return;
    }
    print("✅ Current user ID: ${user.id}");

    try {
      print("🔹 Fetching shared tasks for user...");

      final res = await supabase
          .from('shared_task')
          .select('task_id, tasks(*)')
          .eq('user_id', user.id);

      print("📥 Raw response from Supabase:");
      print(res);

      if (res is! List || res.isEmpty) {
        print("⚠️ No shared tasks found for this user.");
        return;
      }

      print("🔹 Parsing tasks...");
      final parsedTasks =
          res.map<Task>((t) {
            final taskData = t['tasks'];
            print("📌 Mapping shared_task row: $t");

            return Task(
              taskName: taskData["task_name"],
              id: taskData["id"],
              subTask: taskData["sub_task"],
              updatedAt: DateTime.parse(taskData["updated_at"]),
              isCompleted: taskData["is_completed"] ?? false,
            );
          }).toList();

      print("✅ Parsed ${parsedTasks.length} tasks successfully.");

      _shared_tasks.addAll(parsedTasks);
      print("📊 _shared_tasks now has ${_shared_tasks.length} total tasks.");

      notifyListeners();
      print("🔔 notifyListeners called.");
    } catch (e, stackTrace) {
      print("❌ Error in AddingOrgaTasks: $e");
      print("Stack trace: $stackTrace");
    }

    print("🔹 AddingOrgaTasks finished.");
  }
}
