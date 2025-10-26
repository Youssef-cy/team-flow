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

      // تحميل المهام مع فحص الأمان
      try {
        await Future.wait([
          taskProvider.FillTasks(),
          taskProvider.AddingOrgaTasks(),
        ]);
      } catch (e) {
        debugPrint("Error loading tasks: $e");
      }

      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (_isLoading || user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = taskProvider.tasks;
    final List<Task> sharedTasks = taskProvider.sharedTasks;

    final currentTasks = selected == 0 ? sharedTasks : tasks;
    final filteredTasks = currentTasks.where((task) {
      final taskName = task.taskName ?? "";
      return taskName.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

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
                              name: user.name ?? "User",
                              email: user.email ?? "No email",
                              phone: '',
                            ),
                          ),
                        );
                      },
                      child: const Text("🔔", style: TextStyle(fontSize: 25)),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 40 : 25),

                Text(
                  "Hello ${user.name ?? ''}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "You Have\n${filteredTasks.length} Task Today",
                  style: TextStyle(
                    fontSize: (isTablet ? 30 : 28) * textScale,
                    fontWeight: FontWeight.bold,
                  ),
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
                      Icon(Icons.search, color: Colors.grey.shade500),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search task..',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) =>
                              setState(() => searchQuery = value),
                        ),
                      ),
                      const Icon(Icons.tune, color: Colors.black),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Details()),
                        );
                      },
                      child: Icon(Icons.refresh, size: isTablet ? 28 : 22),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 25 : 15),

                // 🗂️ Task cards
                if (filteredTasks.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        "No tasks found",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  )
                else
                  ...filteredTasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final task = entry.value;
                    final color = taskColors[index % taskColors.length];
                    final localDate = (task.updatedAt ?? DateTime.now())
                        .toLocal();
                    final dateText =
                        "${localDate.day} ${_monthName(localDate.month)}";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _buildCard(
                        color: color,
                        title: task.taskName ?? "Untitled",
                        subtitle: task.subTask ?? "",
                        progress: 0.35,
                        date: dateText,
                        isTablet: isTablet,
                        textScale: textScale,
                        pics: task.pics ?? [],
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

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  Widget _buildTab(String label, int index, bool isTablet) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selected = index),
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

  // ✅ تصميم الكارت بنفس الشكل اللي في الصورة
  Widget _buildCard({
    required Color color,
    required String title,
    required String subtitle,
    required double progress,
    required String date,
    required bool isTablet,
    required double textScale,
    required List<String> pics,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // الجزء العلوي (نفس لون الكارت)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (isTablet ? 20 : 16) * textScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: (isTablet ? 14 : 12) * textScale,
                  ),
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(
                  value: progress,
                  color: Colors.white,
                  backgroundColor: Colors.white24,
                  minHeight: 5,
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${(progress * 100).round()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // الجزء الأبيض السفلي (زي الصورة)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Issued to:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (pics.isNotEmpty)
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(pics.first),
                      )
                    else
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Date",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
