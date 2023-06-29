import 'package:flutter/material.dart';

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
      ),
    );
  }
}
