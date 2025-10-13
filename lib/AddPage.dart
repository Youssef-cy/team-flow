import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_team/TaskProvider.dart';
import 'package:task_team/UserProvider.dart';
import 'package:task_team/homepage.dart';
import 'package:task_team/main.dart';
import 'package:task_team/Component/nev_bar.dart';

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
  Map<String, TextEditingController> tasksControllers = {};
  String? emailError; // عشان يظهر الميسج لو الإيميل غلط

  // دالة للتحقق من صحة الإيميل
  bool isValidEmail(String email) {
    // regex بسيط للتحقق من صيغة الايميل
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(email);
  }

  void addEmail() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        emailError = "Please enter an email";
      });
      return;
    } else if (!isValidEmail(email)) {
      setState(() {
        emailError = "Invalid email format";
      });
      return;
    } else if (addedEmails.contains(email)) {
      setState(() {
        emailError = "This email is already added";
      });
      return;
    }

    // لو صح
    setState(() {
      addedEmails.add(email);
      tasksControllers[email] = TextEditingController();
      _emailController.clear();
      emailError = null; // نخفي الغلط
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final taskProvider = Provider.of<TaskProvider>(context);
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
                  'Create New Shared Task',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ===== Project Name =====
              const Text('Task Name *', style: TextStyle(color: Colors.black)),
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
                'Task Description',
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
                        errorText: emailError, // لو فيه غلط هيظهر هنا
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
                      elevation: 5,
                    ),
                    child: const Text(
                      'Add +',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // ===== Emails Cards =====
              ...addedEmails.map(
                (email) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Text(
                                email[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                email,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        var random = Random();
                        final date = DateTime.timestamp();
                        final int id = random.nextInt(100000);
                        // تطبع كل التاسكات الخاصة باليوزرز
                        final data =
                            await supabase.from("tasks").insert({
                              "user_id": user!.id,
                              "id": id,
                              "task_name": _projectNameController.text,
                              "sub_task": _projectDescController.text,
                              "updated_at": date.toString(),
                            }).select();

                        await supabase.from("shared_task").insert({
                          "user_id": user.id,
                          "task_id": data[0]["id"],
                        });

                        print(data.toString());

                        taskProvider.OrgaddTask(
                          Task(
                            taskName: _projectNameController.text,
                            id: id,
                            subTask: _projectDescController.text,
                            updatedAt: date,
                          ),
                        );

                        print("1 ${data.toString()}");

                        for (var email in addedEmails) {
                          print('$email => ${tasksControllers[email]?.text}');
                          final userEmail = await supabase.functions.invoke(
                            'dynamic-action',
                            body: {'email': '${email}'},
                          );

                          print("2 ${userEmail}");
                          final userid = userEmail.data;
                          if (userid["exists"] == false) {
                            continue;
                          }

                          await supabase.from("shared_task").insert({
                            "user_id": userid["user"]["id"],
                            "task_id": data[0]["id"],
                          });
                          print("3");
                        
                        }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
                      NavBarPage(wid: HomePage())
                    ));
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 20,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Create Shared Task',
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
