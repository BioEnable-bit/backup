import 'package:flutter/material.dart';

import 'home.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
        title: const Text("Attendance Dashboard"),
      ),
    );
  }
}
