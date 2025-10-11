import 'package:flutter/material.dart';
import 'package:task_team/TaskProvider.dart';
import 'package:task_team/UserProvider.dart';
import 'package:task_team/profile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool _isLoading = true ;



  @override
  void initState() {
    // FIll all the tasks from the database to be displayed
    WidgetsBinding.instance.addPostFrameCallback((_) async {


      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (taskProvider.sharedTasks.isNotEmpty && taskProvider.tasks.isNotEmpty){
        setState(() => _isLoading = false);
        return;
      }

      await Future.wait([
        taskProvider.FillTasks(),
        taskProvider.AddingOrgaTasks(),
      ]);


      if (mounted) setState(() => _isLoading = false);

    });
    super.initState();
  }

  int selected = 0;

  @override
  Widget build(BuildContext context) {

    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    // if we still fetching data we show a Loading screen
    if (_isLoading == true || user == null) {
      return Center(child: CircularProgressIndicator());
    }



    // the tasks 
    final taskprovider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = taskprovider.tasks;


    // أبعاد الشاشة
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;


    final currentTasks = selected == 0 ? taskprovider.sharedTasks : tasks;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = (constraints.maxWidth / 400).clamp(0.9, 1.3);

          return Padding(
            padding: EdgeInsets.all(isTablet ? 30 : 20),
            child: ListView(
              children: [
                // Top Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.grid_view_rounded, size: isTablet ? 40 : 30),
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
                      child: CircleAvatar(
                        radius: isTablet ? 30 : 20,
                        backgroundImage: NetworkImage(user.profilePic!),
                      ),
                    ),
                  ],
                ),
                // Top Bar
                SizedBox(height: isTablet ? 40 : 25),

                // Title
                Text(
                  "Stay Updated on\nYour Schedule",
                  style: TextStyle(
                    fontSize: (isTablet ? 28 : 22) * textScale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: isTablet ? 30 : 20),

                // Tabs
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

                // Pending Requests
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
                    Icon(Icons.refresh, size: isTablet ? 28 : 22),
                  ],
                ),
                SizedBox(height: isTablet ? 25 : 15),

                // Cards
                ...currentTasks.map((task) {
                  print(task.taskName);
                  final localDate = task.updatedAt!.toLocal();

                  final hour12 = localDate.hour % 12 == 0
                      ? 12
                      : localDate.hour % 12;
                  final period = localDate.hour >= 12 ? "PM" : "AM";

                  // Build formatted string
                  final formatted =
                      "${localDate.year}-"
                      "${localDate.month.toString().padLeft(2, '0')}-"
                      "${localDate.day.toString().padLeft(2, '0')}    "
                      "${hour12.toString().padLeft(2, '0')}:"
                      "${localDate.minute.toString().padLeft(2, '0')}"
                      " $period";
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: _buildCard(
                      color: Colors.red,
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

      // ✅ Floating Action Button
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
        // ignore: deprecated_member_use
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
              ? SizedBox()
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
