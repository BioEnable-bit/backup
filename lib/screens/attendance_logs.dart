import 'package:flutter/material.dart';

import 'home.dart';

class AttendanceLogs extends StatefulWidget {
  const AttendanceLogs({super.key});

  @override
  State<AttendanceLogs> createState() => _AttendanceLogsState();
}

class _AttendanceLogsState extends State<AttendanceLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Logs"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
      ),
    );
  }
}
