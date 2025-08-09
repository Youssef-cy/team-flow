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
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Add Task"),
            content: TextField(
              controller: taskController,
              decoration: InputDecoration(hintText: "Enter task title"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  taskController.clear();
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
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
                child: Text("Add"),
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
    List<Map> tasksToDisplay =
        selected == 0 ? getFilteredTasks(true) : getFilteredTasks(false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: addTaskDialog,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(6),
                child: Icon(Icons.add, size: 30),
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 80,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFilterButton("Complited", 0),
                SizedBox(width: 20),
                _buildFilterButton("Not Complited", 1),
              ],
            ),
          ),
          Expanded(
            child:
                tasksToDisplay.isEmpty
                    ? Center(
                      child: Text(
                        "No tasks",
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: tasksToDisplay.length,
                      itemBuilder: (context, index) {
                        final task = tasksToDisplay[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...task['tasks'].map<Widget>((item) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      item['isCompleted'] =
                                          !item['isCompleted'];
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
                                          color:
                                              item['isCompleted']
                                                  ? Colors.green
                                                  : Colors.grey,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                            color:
                                                item['isCompleted']
                                                    ? Colors.black87
                                                    : Colors.black54,
                                            decoration:
                                                item['isCompleted']
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

  Widget _buildFilterButton(String title, int value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = value;
        });
      },
      child: Container(
        height: 60,
        width: 150,
        decoration: BoxDecoration(
          color: selected == value ? Colors.black : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
