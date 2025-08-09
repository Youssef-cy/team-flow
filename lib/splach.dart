import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:task_team/Component/nev_bar.dart';
import 'dart:async';

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NevBar()),
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
