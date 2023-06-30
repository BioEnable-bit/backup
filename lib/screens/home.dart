import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late String? staffID;
  // late String? designation;

  @override
  void initState() {
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
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                //TODO: ADD USER PROFILE IMAGE HERE
                // image: NetworkImage(url)
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
