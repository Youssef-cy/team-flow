import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // ===== العنوان =====
          Container(
            padding: EdgeInsets.only(
              left: isTablet ? 30 : 20,
              right: isTablet ? 30 : 20,
              top: isTablet ? 70 : 50,
              bottom: isTablet ? 25 : 20,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Chats',
              style: TextStyle(
                color: Colors.black,
                fontSize: isTablet ? 32 : 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ===== الأشخاص الأونلاين =====
          Container(
            padding: EdgeInsets.only(
              left: isTablet ? 30 : 20,
              bottom: isTablet ? 14 : 10,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'Online',
              style: TextStyle(
                color: Colors.black87,
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: isTablet ? 100 : 85,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
              itemCount: 10,
              separatorBuilder: (_, __) =>
                  SizedBox(width: isTablet ? 20 : 16),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: isTablet ? 34 : 28,
                          backgroundImage: const NetworkImage(
                            "https://i.pravatar.cc/150?img=5",
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: isTablet ? 16 : 14,
                            height: isTablet ? 16 : 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'User',
                      style: TextStyle(
                        fontSize: isTablet ? 15 : 13,
                        color: Colors.black,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const Divider(thickness: 0.8),

          // ===== قائمة الشات =====
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (_, __) =>
                  SizedBox(height: isTablet ? 10 : 6),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 12,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 8,
                    vertical: isTablet ? 8 : 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: isTablet ? 34 : 28,
                      backgroundImage: const NetworkImage(
                        "https://i.pravatar.cc/150?img=11",
                      ),
                    ),
                    title: Text(
                      'User Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Last message preview goes here...',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: isTablet ? 15 : 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '10:30 AM',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: isTablet ? 24 : 20,
                          height: isTablet ? 24 : 20,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 13 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // فتح صفحة المحادثة الكاملة
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
