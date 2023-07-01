import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ProfileDataModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String profileImage;
  late String userName;
  late String userDesignation;
  late String userMobile;
  Future<List<ProfileDataModel>> getUserDataFromAPI() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    print(staffID);

    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=show_profile&auth_key=PCMCS56ADDGPIL&staff_id=$staffID'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    print(data);
    setState(() {
      profileImage = data[0]['photo'];
      userName = data[0]['staffname'];
      userDesignation = data[0]['designation'];
      print(data[0]['mobile']);
      userMobile = data[0]['mobile'];
      print(userDesignation);
      print(userMobile);
    });
    return data.map((e) => ProfileDataModel.fromJson(e)).toList();
  }
  // late String? staffID;
  // late String? designation;

  @override
  void initState() {
    userMobile = '';
    profileImage = '';
    userName = '';
    userDesignation = '';

    getUserDataFromAPI();
    // staffID = '';
    // designation = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get data shared with Navigator.pushNamed
    // final arguments = (ModalRoute.of(context)?.settings.arguments ??
    //     <String, dynamic>{}) as Map;
    // Assign value to staffID
    //NOTE: staffID from login and empNo from profile api are same
    // staffID = arguments['staffID'];
    // designation = arguments['designation'];
    // print(designation);
    // print(staffID);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        backgroundColor: Colors.blueGrey, //Colors.blueGrey[900]
        title: const Text('PCMC Staff'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
              ),
              child: Stack(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      //TODO: INSERT profileImage Here
                      backgroundImage: NetworkImage(
                          'http://www.bbk.ac.uk/mce/wp-content/uploads/2015/03/8327142885_9b447935ff.jpg'),
                      radius: 50.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      userName,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight + const Alignment(0, .4),
                    child: Text(
                      userMobile,
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight + Alignment(0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        gradient: const LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          userDesignation,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Attendance Dashboard'),
              leading: const Icon(Icons.perm_identity_rounded),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                // Intent passing with pushName -> you can also pass a string value (just like put extra in android intent passing)
                Navigator.pushNamed(context, '/attendance_dashboard',
                    arguments: {});
              },
            ),
            ListTile(
              title: const Text('Attendance Logs'),
              leading: const Icon(Icons.add_alert),
              onTap: () {
                // Handle item 1 tap
                // Removing Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                Navigator.pushNamed(context, '/attendance_logs', arguments: {});
              },
            ),
            ListTile(
              title: const Text('Monthly Time Card'),
              leading: const Icon(Icons.home),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                Navigator.pushNamed(context, '/time_card', arguments: {});
              },
            ),
            ListTile(
              title: const Text('Fixed Route Map'),
              leading: const Icon(Icons.home),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                Navigator.pushNamed(context, '/route_map', arguments: {});
              },
            ),
            ListTile(
              title: const Text('Profile'),
              leading: const Icon(Icons.home),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                Navigator.pushNamed(context, '/profile', arguments: {});
              },
            ),
            ListTile(
              title: const Text('Tasks List'),
              leading: const Icon(Icons.home),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                Navigator.pushNamed(context, '/tasks_list', arguments: {});
              },
            ),
            ListTile(
              title: const Text('Follow Up'),
              leading: const Icon(Icons.home),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                Navigator.pushNamed(context, '/follow_up', arguments: {});
              },
            ),
            ListTile(
              title: const Text('Alerts'),
              leading: const Icon(Icons.home),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                Navigator.pushNamed(context, '/alerts', arguments: {});
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout_rounded),
              onTap: () {
                // // Removing Navigation Drawer
                // Navigator.pop(context);
                // QuickAlert.show(
                //     context: context,
                //     type: QuickAlertType.confirm,
                //     text: 'Do you want to logout',
                //     confirmBtnText: 'Yes',
                //     cancelBtnText: 'No',
                //     confirmBtnColor: Colors.redAccent,
                //     onCancelBtnTap: () {
                //       Navigator.pop(context);
                //     },
                //     onConfirmBtnTap: () {
                //       // signOut();
                //       // Navigator.pop(context);
                //       // Passing Intent to home screen
                //       // signOut();
                //
                //       Navigator.pushReplacement(context,
                //           MaterialPageRoute(builder: (context) {
                //         return const SignIn();
                //         // Navigator.pop(context);
                //       }));
                //       // Navigator.pop(context);
                //     });
                // // Handle item 1 tap
                // // Intent passing
                // // signOut();
                // // Navigator.pushReplacement(context,
                // //     MaterialPageRoute(builder: (context) {
                // //   return SignInScreen();
                // // }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
