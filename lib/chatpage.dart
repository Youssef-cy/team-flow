import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text(
      //     'Chats',
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      body: Column(
        children: [
          // ===== الأشخاص الأونلاين =====
          Container(
            padding: const EdgeInsets.only(left: 20, top: 50, bottom: 20),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Online',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'User',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                );
              },
            ),
          ),

          Divider(height: 10),

          // ===== الشاتات =====
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (_, __) => const Divider(height: 10),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: const Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Last message preview...',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: const Text(
                    '10:30 AM',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    // هنا ممكن تفتح صفحة الشات الكاملة مع المستخدم
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
