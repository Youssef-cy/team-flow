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

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  /// Get the current logged-in user
  User? getUser() {
    return supabase.auth.currentUser;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = getUser();

      if (user == null) {
        // If no user, go to Signup after 3 seconds
        await Future.delayed(const Duration(seconds: 3));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Signup()),
        );
        return;
      }

      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Wait for BOTH async calls to complete
      await Future.wait([
        taskProvider.FillTasks(),
        userProvider.addUser(user.email!, user.id),
        taskProvider.AddingOrgaTasks(),
      ]);

      // Wait an extra 3 seconds if you want a splash screen effect
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NavBarPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Center(child: LottieBuilder.asset("assets/Checklist.json")),
      ),
    );
  }
}
