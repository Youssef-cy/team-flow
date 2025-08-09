import 'package:flutter/material.dart';
import 'package:task_team/AddPage.dart';
import 'package:task_team/calendarpage.dart';
import 'package:task_team/chatpage.dart';
import 'package:task_team/homepage.dart';
import 'package:task_team/folders.dart';

class NevBar extends StatefulWidget {
  const NevBar({super.key});

  @override
  State<NevBar> createState() => _NevBarState();
}

class _NevBarState extends State<NevBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CalendarPage(),
    const AddPage(),
    ChatPage(),
    const FolderPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            elevation: 20,
            color: Colors.transparent,
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home, 0),
                  _buildNavItem(Icons.task_alt_rounded, 1),
                  const SizedBox(width: 40), // مكان الزر الأوسط
                  _buildNavItem(Icons.chat_bubble_outline, 3),
                  _buildNavItem(Icons.folder, 4),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ✅ نحرك الزر لأسفل باستخدام Transform
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 30), // ⬇️ حرّكه 12 بكسل لأسفل
        child: FloatingActionButton(
          backgroundColor: _selectedIndex == 2 ? Colors.red : Colors.white,
          onPressed: () {
            setState(() {
              _selectedIndex = 2;
            });
          },
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.red : Colors.grey),
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
