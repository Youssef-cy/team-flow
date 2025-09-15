import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_team/Component/nev_bar.dart';
import 'package:task_team/login.dart';
import 'dart:async';

import 'package:task_team/main.dart';
import 'package:task_team/signin.dart';

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
    Timer(const Duration(seconds: 3), () async {
      User? user = await getUser();
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavBarPage()),
        );
      }
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
