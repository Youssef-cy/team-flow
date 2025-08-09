import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;

  const Profile({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  List<Map<String, String>> get userInfo => [
    {'label': 'Name', 'value': widget.name, 'icon': 'person'},
    {'label': 'Email', 'value': widget.email, 'icon': 'email'},
    {'label': 'Password', 'value': widget.password, 'icon': 'lock'},
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

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 100),
          GestureDetector(
            onTap: _pickImage,
            child: Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(60),
                ),
                child:
                    _selectedImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                        : const Center(
                          child: Text(
                            'Select Image',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 534,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'User Information',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ...userInfo.map((item) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(getIcon(item['icon']!)),
                        title: Text(item['label']!),
                        subtitle: Text(item['value']!),
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
