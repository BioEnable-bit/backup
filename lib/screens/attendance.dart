import 'package:flutter/material.dart';
import 'package:pcmc_staff/screens/home_dash.dart';
import 'package:pcmc_staff/screens/team_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendance extends StatefulWidget {
  Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late String? userDesignation;

  @override
  void initState() {
    userDesignation = 'Driver';
    getUserDesignation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: 0,
                bottom: const TabBar(
                  indicatorColor: Colors.blueGrey,
                  tabs: [
                    Tab(
                      // text: "My Dashboard",
                      child: Text(
                        'My Dashboard',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Team Dashboard',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                )),
            body: userDesignation == 'Driver'
                ? const Homedash()
                : const TabBarView(
                    children: [
                      Homedash(),
                      TeamDashboard(),
                    ],
                  )),
      ),
    );
  }

  void getUserDesignation() async {
    final prefs = await SharedPreferences.getInstance();
    var designation = prefs.getString('designation');
    setState(() {
      userDesignation = designation;
    });
  }
}
