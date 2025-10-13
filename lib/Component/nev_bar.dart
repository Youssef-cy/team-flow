import 'package:flutter/material.dart';
import 'package:task_team/AddPage.dart';
import 'package:task_team/calendarpage.dart';
import 'package:task_team/folders.dart';
import 'package:task_team/homepage.dart';

class NavBarPage extends StatefulWidget {
  final Widget wid;
  const NavBarPage({super.key, required this.wid});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _currentIndex = 0;
  late Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    // 👇 Switch between pages depending on index
    switch (_currentIndex) {
      case 0:
        _currentWidget = const HomePage();
        break;
      case 1:
        _currentWidget = const CalendarPage();
        break;
      case 2:
        _currentWidget = const FolderPage();
        break;
      case 3:
        _currentWidget = const AddPage();
        break;
    }

    print("$_currentIndex");

    // معلومات الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600; // لو أكبر من 600 يبقى تابلت أو ديسكتوب

    // حجم الأيقونات ديناميكي
    final double iconSize = isTablet ? 34 : 26;
    final double homeIconSize = isTablet ? 38 : 28;
    final double addIconSize = isTablet ? 55 : 45;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _currentWidget),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 40 : 10,
          vertical: isTablet ? 20 : 12,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isTablet ? 40 : 30),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: homeIconSize),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month, size: iconSize),
                label: 'calendar',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.notifications, size: iconSize),
                label: 'notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  size: addIconSize,
                  color: Colors.green,
                ),
                label: 'add',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
