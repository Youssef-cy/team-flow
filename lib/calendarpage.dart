import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_team/TaskProvider.dart';
import 'package:task_team/main.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool _isLoading = false;
  int selected = 0;
  final TextEditingController taskController = TextEditingController();
  final TextEditingController subtaskController = TextEditingController();

  Future<Task> _addTask(String taskTitle, String? subTask) async {
    print("$taskTitle and $subTask");
    print("subtask ${subTask}");
    var random = Random();
    final int id = random.nextInt(100000);
    final date = DateTime.timestamp();
    final Task task = Task(
      taskName: taskTitle,
      id: id,
      updatedAt: date,
      subTask: subTask == null ? null : subTask,
      shared: false,
    );
    final response = await supabase.from("tasks").insert({
      "user_id": supabase.auth.currentUser!.id,
      "id": id,
      "task_name": taskTitle,
      "sub_task": subTask == null ? null : subTask,
      "updated_at": date.toString(),
    });
    print(response.toString());

    return task;
  }

  void addTaskDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Add Task",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 22 : 18,
              ),
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: isTablet ? 400 : double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        hintText: "Enter task title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: subtaskController,
                      decoration: const InputDecoration(
                        hintText: "Enter subtask title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  taskController.clear();
                  subtaskController.clear();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (taskController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("please enter task title ")),
                          );
                        }
                        else {
                          setStateDialog(() {
                            _isLoading = true;
                          });

                          try {
                            final task = await _addTask(
                              taskController.text.trim(),
                              subtaskController.text.trim(),
                            );

                            if (mounted) {
                              Provider.of<TaskProvider>(
                                context,
                                listen: false,
                              ).addTask(task);

                              Navigator.pop(context);
                              taskController.clear();
                              subtaskController.clear();
                            }
                          } catch (e) {
                            debugPrint("Error adding task: $e");
                          } finally {
                            if (mounted) {
                              setStateDialog(() {
                                _isLoading = false;
                              });
                            }
                          }
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text("Add"),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Task> filteredTasks(List<Task> tasks) {
    List<Task> filtered_tasks = [];
    tasks.map(
      (task) => {
        if (task.isCompleted == true) {filtered_tasks.add(task)},
      },
    );
    return filtered_tasks;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final listOfAllTasks = [...taskProvider.sharedTasks, ...taskProvider.tasks];
    final List<Task> tasksToDisplay = selected == 0
        ? listOfAllTasks.where((t) => t.isCompleted == true).toList()
        : listOfAllTasks.where((task) => task.isCompleted == false).toList();

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "My Tasks",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22 : 18,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTaskDialog,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Icon(Icons.add, color: Colors.white, size: isTablet ? 32 : 28),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Filter Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  _buildFilterButton("Completed", 0, isTablet),
                  _buildFilterButton("Not Completed", 1, isTablet),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: tasksToDisplay.isEmpty
                ? Center(
                    child: Text(
                      "No tasks available",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isTablet ? 20 : 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 40 : 20,
                    ),
                    itemCount: tasksToDisplay.length,
                    itemBuilder: (context, index) {
                      final task = tasksToDisplay[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(isTablet ? 20 : 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              taskProvider.toggleTaskCompletion(task.id);
                              task.updatedAt =
                                  DateTime.now(); // Optional: update timestamp
                            });
                            final res = await supabase
                                .from("tasks")
                                .update({"is_completed": task.isCompleted})
                                .eq("id", task.id);
                            print(res.toString());
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                task.isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: task.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                                size: isTablet ? 26 : 22,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.taskName,
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      color: task.isCompleted
                                          ? Colors.black87
                                          : Colors.black54,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                  task.subTask == null
                                      ? SizedBox()
                                      : Text(
                                          task.subTask == null
                                              ? ""
                                              : task.subTask!,
                                          style: TextStyle(
                                            fontSize: isTablet ? 16 : 14,
                                            color: task.isCompleted
                                                ? Colors.black87
                                                : Colors.black54,
                                            decoration: task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                  task.shared == true
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            top: 15,
                                          ),
                                          child: Text(
                                            "Shared by ${task.email == "Made By you" ? "You" : task.email}",
                                            style: TextStyle(
                                              fontSize: isTablet ? 16 : 14,
                                              color: Colors.blue,
                                              decoration: task.isCompleted
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String title, int value, bool isTablet) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = value;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: selected == value ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected == value ? Colors.white : Colors.black,
                fontSize: isTablet ? 18 : 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
