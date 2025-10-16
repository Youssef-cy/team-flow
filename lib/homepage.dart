import 'package:flutter/material.dart';
import 'package:task_team/TaskProvider.dart';
import 'package:task_team/UserProvider.dart';
import 'package:task_team/details.dart';
import 'package:task_team/profile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  int selected = 0;
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  // ✅ ألوان مختلفة للتسكات
  final List<Color> taskColors = [
    Colors.orange,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (taskProvider.sharedTasks.isNotEmpty &&
          taskProvider.tasks.isNotEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      await Future.wait([
        taskProvider.FillTasks(),
        taskProvider.AddingOrgaTasks(),
      ]);

      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (_isLoading == true || user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final taskprovider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = taskprovider.tasks;

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // 🧠 استخدم الليست الحالية
    final currentTasks = selected == 0 ? taskprovider.sharedTasks : tasks;

    print("selected $selected");

    // 🔍 فلترة حسب السيرش
    final filteredTasks = currentTasks.where((task) {
      return task.taskName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = (constraints.maxWidth / 400).clamp(0.9, 1.3);

          return Padding(
            padding: EdgeInsets.all(isTablet ? 30 : 20),
            child: ListView(
              children: [
                // 🔝 Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.sort, size: isTablet ? 40 : 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                              name: user.name!,
                              email: user.email,
                              phone: '',
                            ),
                          ),
                        );
                      },
                      child: Text("🔔", style: TextStyle(fontSize: 25)),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 40 : 25),

                // 👋 Welcome user
                Text("Hello ${user.name ?? ''}"),

                // 📌 Title
                Text(
                  "You Have\n${filteredTasks.length} Task Today",
                  style: TextStyle(
                    fontSize: (isTablet ? 30 : 28) * textScale,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),

                SizedBox(height: isTablet ? 30 : 20),

                // 🔍 Search bar
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade500, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(18),
                            hintText: 'Search task..',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                      ),
                      Icon(Icons.tune, color: Colors.black, size: 24),
                    ],
                  ),
                ),

                SizedBox(height: isTablet ? 30 : 20),

                // 🧭 Tabs
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      _buildTab("Organization", 0, isTablet),
                      _buildTab("My Space", 1, isTablet),
                    ],
                  ),
                ),

                SizedBox(height: isTablet ? 35 : 25),

                // ⏳ Pending Requests
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pending Requests",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 20 : 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Details()),
                          );
                        });
                      },
                      child: Icon(Icons.refresh, size: isTablet ? 28 : 22),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 25 : 15),

                // 🗂️ Cards
                ...filteredTasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;

                  final localDate = task.updatedAt!.toLocal();

                  final hour12 = localDate.hour % 12 == 0
                      ? 12
                      : localDate.hour % 12;
                  final period = localDate.hour >= 12 ? "PM" : "AM";
                  print(task.email ?? "null");
                  String email = task.email ?? "By you";

                  final formatted =
                      "${localDate.year}-"
                      "${localDate.month.toString().padLeft(2, '0')}-"
                      "${localDate.day.toString().padLeft(2, '0')}    "
                      "${hour12.toString().padLeft(2, '0')}:" // وقت
                      "${localDate.minute.toString().padLeft(2, '0')} $period"
                      "\n$email"
                      "${task.shared == true ? "  Shared task" : ""}";

                  final color = taskColors[index % taskColors.length];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildCard(
                      color: color,
                      title: task.taskName,
                      subtitle: task.subTask ?? "",
                      footer: formatted,
                      isTablet: isTablet,
                      textScale: textScale,
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTab(String label, int index, bool isTablet) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: selected == index ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected == index ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: isTablet ? 18 : 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required Color color,
    required String title,
    required String subtitle,
    required String footer,
    required bool isTablet,
    required double textScale,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isTablet ? 24 : 18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (isTablet ? 20 : 16) * textScale,
            ),
          ),
          SizedBox(height: isTablet ? 10 : 8),
          subtitle == ""
              ? const SizedBox()
              : Text(
                  subtitle,
                  style: TextStyle(fontSize: (isTablet ? 16 : 14) * textScale),
                ),
          SizedBox(height: isTablet ? 16 : 12),
          Text(footer, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
