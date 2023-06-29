import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pcmc_staff/screens/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool? flag = false;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      // Intent Passing
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/splash_screen.jpeg'),
        ),
      ),
    );
  }
}
