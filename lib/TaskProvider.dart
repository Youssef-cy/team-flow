import 'package:flutter/foundation.dart';
import 'package:task_team/main.dart';

class Task {
  int id;
  String taskName;
  String? subTask;
  DateTime? updatedAt;
  bool isCompleted;
  bool shared;
  String? email;
  Task({
    required this.taskName,
    this.updatedAt,
    this.subTask,
    this.isCompleted = false,
    required this.shared,
    this.email,
    required this.id,
  });
}

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  final List<Task> _shared_tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  List<Task> get sharedTasks => List.unmodifiable(_shared_tasks);

  Future<bool?> FillTasks() async {
    final user = supabase.auth.currentUser;

    // If no user is logged in, return early
    if (user == null) {
      print("No user logged in. Skipping FillTasks.");
      return false;
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
      
      var rpcResponse ;
      final tasks = await Future.wait(
        response.map((task) async {
          if (task["shared"] == true) {
            rpcResponse = await supabase.rpc(
              'get_task_owner',
              params: {'p_task_id': task["id"]},
            );
            print('Owner: $rpcResponse');
          }

          return Task(
            taskName: task["task_name"] ?? '',
            id: task["id"],
            subTask: task["sub_task"],
            updatedAt: DateTime.parse(task["updated_at"]),
            isCompleted: task["is_completed"] ?? false,
            shared: task["shared"],
            email: "Made by you"
          );
        }),
      );

      _tasks.addAll(tasks);

      if (_tasks.isEmpty) {
        print("There is no tasks for this user");
        return null;
      }

      // Notify listeners so UI rebuilds
      notifyListeners();
      print("Tasks updated. Total: ${_tasks.length}");
      return true;
    } catch (error) {
      print("Error fetching tasks: $error");
      return false;
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

  Future<bool?> AddingOrgaTasks() async {
    print("🔹 AddingOrgaTasks started...");

    final user = supabase.auth.currentUser;
    if (user == null) {
      print("❌ No authenticated user found!");
      return false;
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

      if (res.isEmpty) {
        print("⚠️ No shared tasks found for this user.");
        return null;
      }

      print("🔹 Parsing tasks...");


      var rpcResponse ;
      final tasks = await Future.wait(
        res.map((task) async {
          if (task["tasks"]["shared"] == true) {
            rpcResponse = await supabase.rpc(
              'get_task_owner',
              params: {'p_task_id': task["id"]},
            );
            print('Owner: $rpcResponse');
          }

          return Task(
            taskName: task["tasks"]["task_name"] ?? '',
            id: task["tasks"]["id"],
            subTask: task["tasks"]["sub_task"],
            updatedAt: DateTime.parse(task["tasks"]["updated_at"]),
            isCompleted: task["tasks"]["is_completed"] ?? false,
            shared: task["tasks"]["shared"],
            email: rpcResponse
          );
        }),
      );




      final parsedTasks = tasks;

      print("✅ Parsed ${parsedTasks.length} tasks successfully.");

      _shared_tasks.addAll(parsedTasks);
      print("📊 _shared_tasks now has ${_shared_tasks.length} total tasks.");

      notifyListeners();
      print("🔔 notifyListeners called.");
    } catch (e, stackTrace) {
      print("❌ Error in AddingOrgaTasks: $e");
      print("Stack trace: $stackTrace");
      return false;
    }

    print("🔹 AddingOrgaTasks finished.");
    return true;
  }
}
