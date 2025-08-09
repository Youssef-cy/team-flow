import 'package:flutter/material.dart';
import 'package:task_team/Task_all%20.dart';
import 'package:task_team/login.dart';
import 'package:task_team/projectpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String name = "Alex";

  List<Map> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    filteredTasks = List.from(globalTasks);
    _searchController.addListener(_filterTasks);
  }

  void _filterTasks() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredTasks = List.from(globalTasks);
      } else {
        filteredTasks =
            globalTasks.where((task) {
              final title = (task['title'] ?? '').toString().toLowerCase();
              final subtasks = (task['tasks'] as List?) ?? [];

              final foundInSubtasks = subtasks.any((sub) {
                if (sub is Map && sub['name'] is String) {
                  return sub['name'].toLowerCase().contains(query);
                }
                return false;
              });

              return title.contains(query) || foundInSubtasks;
            }).toList();
      }
    });
  }

  List<Map> projects = [
    {
      "name": "Pizza & Pints",
      "date": "10 Feb 2023  10:30 AM",
      "members": "+2",
      "progress": "24%",
      "tasks": "14 of 22 tasks completed",
    },
    {
      "name": "Mobile App Design",
      "date": "15 Mar 2023  02:00 PM",
      "members": "+5",
      "progress": "65%",
      "tasks": "26 of 40 tasks completed",
    },
    {
      "name": "Website Redesign",
      "date": "20 Jan 2023  09:15 AM",
      "members": "+3",
      "progress": "90%",
      "tasks": "9 of 10 tasks completed",
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Container(
              height: 60,
              width: double.infinity,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Title(
                    color: Colors.black,
                    child: Text(
                      "Welcome Back $name",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.notifications),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Icon(Icons.person, size: 28),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for Task...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProjectPage(
                                projectName: project["name"],
                                date: project["date"],
                                completedTasks: int.parse(
                                  project["tasks"].split(' ')[0],
                                ),
                                totalTasks: int.parse(
                                  project["tasks"].split(' ')[2],
                                ),
                                taskTitle: null,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      width: 250,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 20 : 10,
                        right: index == projects.length - 1 ? 20 : 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project["name"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            project["date"],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            project["progress"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            project["tasks"],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
            const Row(
              children: [
                SizedBox(width: 30),
                Text(
                  "Your Task Today's",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  final subtasks = (task['tasks'] as List?) ?? [];

                  return Container(
                    // تم تغيير InkWell إلى Container هنا
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
                          task['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...subtasks.asMap().entries.map((entry) {
                          final item = entry.value as Map;

                          return InkWell(
                            onTap: () {
                              final isCompleted = item['isCompleted'] ?? false;
                              setState(() {
                                item['isCompleted'] = !isCompleted;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item['isCompleted'] == true
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color:
                                        item['isCompleted'] == true
                                            ? Colors.green
                                            : Colors.grey,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['name'] ?? '',
                                    style: TextStyle(
                                      color:
                                          item['isCompleted'] == true
                                              ? Colors.black87
                                              : Colors.black,
                                      decoration:
                                          item['isCompleted'] == true
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
      ),
    );
  }
}
