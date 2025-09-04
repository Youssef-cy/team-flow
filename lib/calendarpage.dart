import 'package:flutter/material.dart';
import 'package:task_team/Task_all%20.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int selected = 0;
  final TextEditingController taskController = TextEditingController();

  void addTaskDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                setState(() {
                  globalTasks.add({
                    "title": taskController.text,
                    "tasks": [
                      {"name": "Subtask", "isCompleted": false},
                    ],
                  });
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

  List<Map> getFilteredTasks(bool completed) {
    return globalTasks
        .where(
          (task) => task['tasks'].every(
            (subtask) => subtask['isCompleted'] == completed,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    List<Map> tasksToDisplay =
        selected == 0 ? getFilteredTasks(true) : getFilteredTasks(false);

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
                    padding:
                        EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'],
                              style: TextStyle(
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...task['tasks'].map<Widget>((item) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    item['isCompleted'] = !item['isCompleted'];
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        item['isCompleted']
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: item['isCompleted']
                                            ? Colors.green
                                            : Colors.grey,
                                        size: isTablet ? 26 : 22,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          color: item['isCompleted']
                                              ? Colors.black87
                                              : Colors.black54,
                                          decoration: item['isCompleted']
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
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
