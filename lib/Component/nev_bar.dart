import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:task_team/homepage.dart';
import 'package:task_team/calendarpage.dart';
import 'package:task_team/folders.dart';
import 'package:task_team/AddPage.dart';
import 'package:task_team/profile.dart';
import 'package:task_team/UserProvider.dart';

class Navbar extends StatefulWidget {
  final Widget wid;
  const Navbar({super.key, required this.wid});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  late Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    // 🧠 نجيب بيانات اليوزر من UserProvider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // 🔹 لوجيك التبديل بين الصفحات
    switch (_currentIndex) {
      case 0:
        _currentWidget = const HomePage();
        break;
      case 1:
        _currentWidget = const CalendarPage();
        break;
      case 2:
        _currentWidget = const AddPage();
        break;
      case 3:
        _currentWidget = const FolderPage();
        break;
      case 4:
        _currentWidget = Profile(
          name: user?.name ?? "User",
          email: user?.email ?? "No Email",
          phone: '',
        );
        break;
      default:
        _currentWidget = const HomePage();
    }

    // 🎨 ألوان لكل تاب
    final List<Color> tabColors = [
      Colors.blueAccent, // Home
      Colors.redAccent, // My Task
      Colors.orangeAccent, // Folders
      Colors.green, // Add Task
      Colors.purple, // Profile
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(child: _currentWidget),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  iconSize: 26,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: tabColors[_currentIndex].withOpacity(
                    0.15,
                  ),
                  activeColor: tabColors[_currentIndex],
                  color: Colors.black87,
                  tabs: const [
                    GButton(icon: LineIcons.home, text: 'Home'),
                    GButton(icon: LineIcons.list, text: 'My Task'),
                    GButton(icon: LineIcons.plusCircle, text: 'Add Task'),
                    GButton(icon: LineIcons.folder, text: 'Folders'),
                    GButton(icon: LineIcons.user, text: 'Profile'),
                  ],
                  selectedIndex: _currentIndex,
                  onTabChange: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
