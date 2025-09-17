import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_team/Component/nev_bar.dart';
import 'package:task_team/Signup.dart';
import 'package:task_team/TaskProvider.dart';
import 'package:task_team/UserProvider.dart';
import 'dart:async';

import 'package:task_team/main.dart';
import 'package:task_team/profile.dart';

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  Future<User?> getUser() async {
    final session = supabase.auth.currentSession; // No await here
    return session?.user; // Safely return user or null
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait for the provider to finish loading

      User? user = await getUser();
      if (user == null) {
        Timer(const Duration(seconds: 3), () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Signup()),
          );
        });
        return;
      }
      await Provider.of<TaskProvider>(context, listen: false).FillTasks();
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).addUser(user.email!, user.id);
      // After tasks are loaded, wait 3 seconds and then navigate
      Timer(const Duration(seconds: 3), () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBarPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskProvider>(context, listen: false).FillTasks();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Center(child: LottieBuilder.asset("assets/Checklist.json")),
      ),
    );
  }
}
