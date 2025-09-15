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
  int selected = 0;
  final TextEditingController taskController = TextEditingController();

  Future<Task> _addTask(String taskTitle, String? subTask) async {
    var random = Random();
    final int id = random.nextInt(100000);
    final date = DateTime.timestamp();
    final Task task = Task(taskName: taskTitle, id: id, updatedAt: date);
    final response = await supabase.from("tasks").insert({
      "user_id": supabase.auth.currentUser!.id,
      "id": id,
      "task_name": taskTitle,
      "sub_task": subTask == null ? subTask : null,
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
      builder:
          (_) => AlertDialog(
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
            content: TextField(
              controller: taskController,
              decoration: const InputDecoration(
                hintText: "Enter task title",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  taskController.clear();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (taskController.text.isNotEmpty) {
                    final task = await _addTask(taskController.text, null);
                    setState(() {
                      Provider.of<TaskProvider>(context, listen: false).addTask(
                        task,
                      ); // this is how u add a task u make a task object then pass it to this method
                    });
                    Navigator.pop(context);
                    taskController.clear();
                  }
                },
                child: const Text("Add"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasksToDisplay =
        taskProvider.tasks; // this is the tasks every task is Task object
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
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

          // Tasks List
          //          Expanded(
          //            child:
          //                tasksToDisplay.isEmpty
          //                    ? Center(
          //                      child: Text(
          //                        "No tasks available",
          //                        style: TextStyle(
          //                          color: Colors.grey,
          //                          fontSize: isTablet ? 20 : 16,
          //                        ),
          //                      ),
          //                    )
          //                    : ListView.builder(
          //                      padding: EdgeInsets.symmetric(
          //                        horizontal: isTablet ? 40 : 20,
          //                      ),
          //                      itemCount: tasksToDisplay.length,
          //                      itemBuilder: (context, index) {
          //                        final task = tasksToDisplay[index];
          //                        return Container(
          //                          margin: const EdgeInsets.only(bottom: 16),
          //                          padding: EdgeInsets.all(isTablet ? 20 : 16),
          //                          decoration: BoxDecoration(
          //                            color: Colors.white,
          //                            borderRadius: BorderRadius.circular(16),
          //                            boxShadow: [
          //                              BoxShadow(
          //                                color: Colors.black.withOpacity(0.05),
          //                                blurRadius: 8,
          //                                offset: const Offset(0, 4),
          //                              ),
          //                            ],
          //                          ),
          //                          child: Column(
          //                            crossAxisAlignment: CrossAxisAlignment.start,
          //                            children: [
          //                              Text(
          //                                task.taskName,
          //                                style: TextStyle(
          //                                  fontSize: isTablet ? 18 : 16,
          //                                  fontWeight: FontWeight.bold,
          //                                ),
          //                              ),
          //                              const SizedBox(height: 12),
          //                              ...task.map<Widget>((item) {
          //                                return InkWell(
          //                                  onTap: () {
          //                                    setState(() {
          //                                      item['isCompleted'] =
          //                                          !item['isCompleted'];
          //                                    });
          //                                  },
          //                                  child: Padding(
          //                                    padding: const EdgeInsets.symmetric(
          //                                      vertical: 6,
          //                                    ),
          //                                    child: Row(
          //                                      children: [
          //                                        Icon(
          //                                          item['isCompleted']
          //                                              ? Icons.check_circle
          //                                              : Icons.radio_button_unchecked,
          //                                          color:
          //                                              item['isCompleted']
          //                                                  ? Colors.green
          //                                                  : Colors.grey,
          //                                          size: isTablet ? 26 : 22,
          //                                        ),
          //                                        const SizedBox(width: 8),
          //                                        Text(
          //                                          item['name'],
          //                                          style: TextStyle(
          //                                            fontSize: isTablet ? 16 : 14,
          //                                            color:
          //                                                item['isCompleted']
          //                                                    ? Colors.black87
          //                                                    : Colors.black54,
          //                                            decoration:
          //                                                item['isCompleted']
          //                                                    ? TextDecoration.lineThrough
          //                                                    : TextDecoration.none,
          //                                          ),
          //                                        ),
          //                                      ],
          //                                    ),
          //                                  ),
          //                                );
          //                              }).toList(),
          //                            ],
          //                          ),
          //                        );
          //                      },
          //                    ),
          //          ),
          //
          Expanded(
            child:
                tasksToDisplay.isEmpty
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
                            onTap: () {
                              setState(() {
                                task.isCompleted = !task.isCompleted;
                                task.updatedAt =
                                    DateTime.now(); // Optional: update timestamp
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  task.isCompleted
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color:
                                      task.isCompleted
                                          ? Colors.green
                                          : Colors.grey,
                                  size: isTablet ? 26 : 22,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    task.taskName,
                                    style: TextStyle(
                                      fontSize: isTablet ? 16 : 14,
                                      color:
                                          task.isCompleted
                                              ? Colors.black87
                                              : Colors.black54,
                                      decoration:
                                          task.isCompleted
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                    ),
                                  ),
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
