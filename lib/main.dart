import 'package:flutter/material.dart';
import 'package:pcmc_staff/screens/alerts.dart';
import 'package:pcmc_staff/screens/attendance_dashboard.dart';
import 'package:pcmc_staff/screens/attendance_logs.dart';
import 'package:pcmc_staff/screens/follow_up_list.dart';
import 'package:pcmc_staff/screens/forgot_password.dart';
import 'package:pcmc_staff/screens/home.dart';
import 'package:pcmc_staff/screens/monthly_timecard.dart';
import 'package:pcmc_staff/screens/profile.dart';
import 'package:pcmc_staff/screens/route_map.dart';
import 'package:pcmc_staff/screens/sign_in.dart';
import 'package:pcmc_staff/screens/task_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //Colors
  // App Bar Background - B8B8FF Alternative - 3CBBB1
  // Buttons background - 0C1411
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PCMC Staff',
      routes: {
        '/sign_in': (context) => const SignIn(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/home': (context) => const Home(),
        '/attendance_dashboard': (context) => const AttendanceDashboard(),
        '/attendance_logs': (context) => const AttendanceLogs(),
        '/time_card': (context) => const MonthlyTimeCard(),
        '/route_map': (context) => const RouteMap(),
        '/profile': (context) =>
            const Profile(), // from profile when user clicks on edit/update - he/she can update profile with profileUpdate Alert Dialog
        '/tasks_list': (context) => const TaskList(),
        '/follow_up': (context) => const FollowUpList(),
        '/alerts': (context) => const Alerts(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,

      ),
      debugShowCheckedModeBanner: false,
      home: const SignIn(),
    );
  }
}
