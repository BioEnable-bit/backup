import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pcmc_staff/screens/attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'attendance_logs.dart';
import 'home.dart';
import 'home_supervisor.dart';
import 'monthly_timecard.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate to mark attendance the app',
      );
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    if (authenticated) {
      print('authenticated');
      // TODO: MARK ATTENDANCE
    }
  }

  late String? staffID;
  late String? userDesignation;
  int _currentindex = 0;
  final List<Widget> _children = [
    //Screen(),
    Attendance(),
    AttendanceLogs(),
    MonthlyTimeCard()
  ];
  void ontabbar(int index) {
    setState(() {
      _currentindex = index;
    });
  }

  @override
  void initState() {
    staffID = '';
    userDesignation = '';
    getUserDetails();

    super.initState();
  }

  void getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      staffID = prefs.getString('staffID');
      userDesignation = prefs.getString('designation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () => userDesignation == 'Driver'
              ? Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                  return const Home();
                  // Navigator.pop(context);
                }))
              : Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                  return const HomeSupervisor();
                  // Navigator.pop(context);
                })),
        ),
        title: const Text("Attendance Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.fingerprint_sharp,
                color: Colors.blueGrey, size: 34.89),
            onPressed: () {
              _authenticate();
            },
          )
        ],
      ),
      body: _children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: ontabbar,
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.timelapse),
              label: 'Logs',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              label: 'Time Card',
              backgroundColor: Colors.blue),
        ],
      ),
    );
  }
}
