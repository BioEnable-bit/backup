import 'package:flutter/material.dart';
import 'package:pcmc_staff/screens/Homedash.dart';

import 'attendance_logs.dart';
import 'home.dart';
import 'monthly_timecard.dart';

class AttendanceDashboard extends StatefulWidget {
  const AttendanceDashboard({super.key});

  @override
  State<AttendanceDashboard> createState() => _AttendanceDashboardState();
}

class _AttendanceDashboardState extends State<AttendanceDashboard> {

  int _currentindex=0;
  final List<Widget> _children=[
    Homedash(),
    AttendanceLogs(),
    MonthlyTimeCard()

  ];
  void ontabbar(int index){
    setState(() {

_currentindex=index;
    });

  }





  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
        title: const Text("Attendance Dashboard"),actions: [
        IconButton(
          icon: const Icon(Icons.fingerprint_sharp, color: Colors.blueGrey,size: 34.89),
          onPressed: () {
            // TODO: Add Alerts popup functionality
            print('clicked');
          },
        )
      ],
      ),

      body:_children[_currentindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: ontabbar,
        currentIndex: _currentindex,
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          items: [BottomNavigationBarItem(
              icon:Icon(Icons.home),label: 'Home',backgroundColor: Colors.blue




          ),
            BottomNavigationBarItem(
                icon:Icon(Icons.timelapse),label: 'Logs',backgroundColor: Colors.blue




            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.access_time),label: 'Time Card',backgroundColor: Colors.blue




            ),




          ],



      ),
    );
  }
}
