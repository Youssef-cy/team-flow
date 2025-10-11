import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<Map<String, dynamic>> tasks = [
    {'title': 'UI Design', 'completed': false},
    {'title': 'Logo Designer', 'completed': false},
    {'title': 'Profile Page', 'completed': false},
  ];

  void pickFile(int index) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        tasks[index]['completed'] = true;
      });
    }
  }

  Widget buildTaskItem(int index) {
    final task = tasks[index];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.folder_open, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task['title'],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          IconButton(
            onPressed: () => pickFile(index),
            icon: Icon(
              task['completed'] ? Icons.check_circle : Icons.cloud_upload_outlined,
              color: task['completed'] ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Folder", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) => buildTaskItem(index),
      ),
    );
  }
}
