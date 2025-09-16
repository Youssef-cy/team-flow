import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task_team/UserProvider.dart';

class Profile extends StatefulWidget {
  final String name;
  final String email;
  final String phone;

  const Profile({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();

  List<Map<String, String>> get userInfo => [
    {'label': 'Name', 'value': widget.name, 'icon': 'person'},
    {'label': 'Email', 'value': widget.email, 'icon': 'email'},
  ];

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'lock':
        return Icons.lock;
      default:
        return Icons.info;
    }
  }

  Future<XFile?> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return pickedFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      backgroundColor: Colors.white,
      // TODO : please for the love of god add a back button to make debuging on desktop easier
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 16,
            vertical: 20,
          ),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.1),
              GestureDetector(
                onTap: () async {
                  final photo = await _pickImage();
                  await userProvider.updateProfilePic(photo!);
                  setState(() {});
                },
                child: Center(
                  child: Container(
                    height: isTablet ? 150 : 120,
                    width: isTablet ? 150 : 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        user!.profilePic!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // User Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Information',
                      style: TextStyle(
                        fontSize: isTablet ? 26 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...userInfo.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              getIcon(item['icon']!),
                              size: isTablet ? 30 : 24,
                            ),
                            title: Text(
                              item['label']!,
                              style: TextStyle(fontSize: isTablet ? 18 : 16),
                            ),
                            subtitle: Text(
                              item['value']!,
                              style: TextStyle(fontSize: isTablet ? 16 : 14),
                            ),
                          ),
                          if (index != userInfo.length - 1)
                            const Divider(), // ✅ Only show divider if NOT last
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
