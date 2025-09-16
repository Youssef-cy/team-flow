import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int selectedMembers = 2;
  List<String> addedEmails = [];

  void addEmail() {
    if (_emailController.text.isNotEmpty &&
        !addedEmails.contains(_emailController.text)) {
      setState(() {
        addedEmails.add(_emailController.text);
        _emailController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'Create New Project',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Project Name *',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _projectNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Project Description',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _projectDescController,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Number of Members',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                // ignore: deprecated_member_use
                value: selectedMembers,
                items:
                    List.generate(10, (index) => index + 1)
                        .map(
                          (num) =>
                              DropdownMenuItem(value: num, child: Text('$num')),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMembers = value ?? 2;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Add Members (Email)',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'example@email.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      elevation: 20,
                    ),
                    child: const Text(
                      'Add +',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              ...addedEmails.map(
                (email) => Text(
                  '- $email',
                  style: const TextStyle(color: Colors.black),
                ),
              ),

              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Project creation logic goes here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 20,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Create Project',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
