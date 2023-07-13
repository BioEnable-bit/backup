import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/screens/sign_in.dart';
import 'package:pcmc_staff/screens/task_list.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ProfileDataModel.dart';

class HomeSupervisor extends StatefulWidget {
  const HomeSupervisor({super.key});

  @override
  State<HomeSupervisor> createState() => _HomeSupervisorState();
}

class _HomeSupervisorState extends State<HomeSupervisor> {
  static String? designation;
  String? getDesignation() => designation;
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
      designation = data[0][
          'designation']; //using designation variable value to decide whether to show add task option in tasks list screen app bar or not
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
    List imageList = [
      //TODO: Change Image Path to add new images
      {"id": 0, "image_path": 'assets/home_image_one.png'},
      {"id": 1, "image_path": 'assets/home_image_one.png'},
      // {"id": 2, "image_path": 'assets/take_survey_home.png'},
      // {"id": 3, "image_path": 'assets/garbage_status_home.png'},
      // {"id": 4, "image_path": 'assets/guidelines_home.png'},
      // {"id": 5, "image_path": 'assets/helpline_home.png'}
    ];
    final CarouselController carouselController =
        CarouselController(); //carousal step 3

    int currentIndex = 0;

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
        actions: [
          RawMaterialButton(
            elevation: 1.0,
            fillColor: const Color(0xFFF5F6F9),
            padding: const EdgeInsets.all(5.0),
            shape: const CircleBorder(),
            onPressed: () {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Do you want to logout',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: Colors.redAccent,
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  },
                  onConfirmBtnTap: () {
                    // signOut();
                    // Navigator.pop(context);
                    // Passing Intent to home screen
                    // signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignIn();
                      // Navigator.pop(context);
                    }));
                    // Navigator.pop(context);
                  });
            },
            child: const Icon(
              Icons.logout,
              color: Colors.blue,
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.logout_rounded, color: Colors.white),
          //   onPressed: () {
          //     QuickAlert.show(
          //         context: context,
          //         type: QuickAlertType.confirm,
          //         text: 'Do you want to logout',
          //         confirmBtnText: 'Yes',
          //         cancelBtnText: 'No',
          //         confirmBtnColor: Colors.redAccent,
          //         onCancelBtnTap: () {
          //           Navigator.pop(context);
          //         },
          //         onConfirmBtnTap: () {
          //           // signOut();
          //           // Navigator.pop(context);
          //           // Passing Intent to home screen
          //           // signOut();
          //           Navigator.pushReplacement(context,
          //               MaterialPageRoute(builder: (context) {
          //             return const SignIn();
          //             // Navigator.pop(context);
          //           }));
          //           // Navigator.pop(context);
          //         });
          //   },
          // )
        ],
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: profileImage != ''
                        ? SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipOval(
                              child: Image.memory(
                                const Base64Decoder().convert(
                                  profileImage.toString(),
                                ),
                              ),
                            ),
                          )
                        : Image.asset('assets/profile.png'),
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
              leading: const Icon(Icons.perm_identity_rounded,
                  color: Color(0xff0D0F2F)),
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
            // ListTile(
            //   title: const Text('Attendance Logs'),
            //   leading: const Icon(Icons.add_alert),
            //   onTap: () {
            //     // Handle item 1 tap
            //     // Removing Navigation Drawer
            //     Navigator.pop(context);
            //     // Intent passing
            //     Navigator.pushNamed(context, '/attendance_logs', arguments: {});
            //   },
            // ),
            // ListTile(
            //   title: const Text('Monthly Time Card'),
            //   leading: const Icon(Icons.home),
            //   onTap: () {
            //     // Handle item 1 tap Intent Passing
            //     // Remove Navigation Drawer
            //     Navigator.pop(context);
            //     // Intent passing
            //     Navigator.pushNamed(context, '/time_card', arguments: {});
            //   },
            // ),
            ListTile(
              title: const Text('Fixed Route Map'),
              leading: const Icon(Icons.location_on, color: Color(0xff0D0F2F)),
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
              leading:
                  const Icon(Icons.account_circle, color: Color(0xff0D0F2F)),
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
              leading: const Icon(Icons.task_rounded, color: Color(0xff0D0F2F)),
              onTap: () {
                // Handle item 1 tap Intent Passing
                // Remove Navigation Drawer
                Navigator.pop(context);
                // Intent passing
                // Navigator.pushNamed(context, '/tasks_list', arguments: {});
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return TaskList();
                  // Navigator.pop(context);
                }));
              },
            ),
            ListTile(
              title: const Text('Follow Up'),
              leading: const Icon(Icons.follow_the_signs_rounded,
                  color: Color(0xff0D0F2F)),
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
              leading: const Icon(Icons.add_alert, color: Color(0xff0D0F2F)),
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
              leading:
                  const Icon(Icons.logout_rounded, color: Color(0xff0D0F2F)),
              onTap: () {
                // Removing Navigation Drawer
                Navigator.pop(context);
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'Do you want to logout',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: Colors.redAccent,
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    },
                    onConfirmBtnTap: () {
                      // signOut();
                      // Navigator.pop(context);
                      // Passing Intent to home screen
                      // signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignIn();
                        // Navigator.pop(context);
                      }));
                      // Navigator.pop(context);
                    });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Column(
            //carousal step 5
            children: [
              // for image slider
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      // This is a function to handle image tap
                      // migrateToSelectedImageScreen(currentIndex); -> if need to add this feature function code from citizen app
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //     content: Text('image clicked at $currentIndex')));
                      return;
                    },
                    child: CarouselSlider(
                        //carousal step 6 -> sliding effect
                        items: imageList
                            .map(
                              (item) => Image.asset(
                                item['image_path'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                            scrollPhysics: const BouncingScrollPhysics(),
                            autoPlay: true,
                            aspectRatio: 2,
                            viewportFraction: 1,
                            onPageChanged: (index, reason) {
                              setState(() {
                                currentIndex = index;
                              });
                            })),
                  ),
                  // Positioned(
                  //   bottom: 10,
                  //   left: 0,
                  //   right: 0,
                  //   child: Row(
                  //     //carousal step 7 sliding dots
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children:
                  //         imageList.asMap().entries.map((entry) {
                  //       // Moving Dot
                  //       return GestureDetector(
                  //         onTap: () => carouselController
                  //             .animateToPage(entry.key),
                  //         child: Container(
                  //           width: currentIndex == entry.key ? 17 : 7,
                  //           height: 7.0,
                  //           margin: const EdgeInsets.symmetric(
                  //             horizontal: 3.0,
                  //           ),
                  //           decoration: BoxDecoration(
                  //               borderRadius:
                  //                   BorderRadius.circular(10),
                  //               color: currentIndex == entry.key
                  //                   ? Colors
                  //                       .red // current image dot color
                  //                   : Colors
                  //                       .teal), //other image dot color
                  //         ),
                  //       );
                  //     }).toList(),
                  //     //
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              //Boxes with menu code
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 8.0,
                        child: Ink(
                          width: 150,
                          height: 100,
                          // color: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            gradient: const LinearGradient(
                                colors: [Colors.blueGrey, Colors.lightBlue],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Function to be called when container is tapped
                              Navigator.pushNamed(
                                  context, '/attendance_dashboard',
                                  arguments: {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    elevation: 1.0,
                                    fillColor: const Color(0xFFF5F6F9),
                                    padding: const EdgeInsets.all(5.0),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/attendance_dashboard',
                                          arguments: {});
                                    },
                                    child: const Icon(
                                      Icons.dashboard_customize_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),

                                  //HERE
                                  const Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text('Attendance',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.00,
                      ),
                      Card(
                        elevation: 8.0,
                        child: Ink(
                          width: 150,
                          height: 100,
                          // color: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            gradient: const LinearGradient(
                                colors: [Colors.blueGrey, Colors.lightBlue],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/new_task',
                                  arguments: {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    elevation: 1.0,
                                    fillColor: const Color(0xFFF5F6F9),
                                    padding: const EdgeInsets.all(5.0),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/new_task',
                                          arguments: {});
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const Text('Add New Task',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 8.0,
                        child: Ink(
                          width: 150,
                          height: 100,
                          // color: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            gradient: const LinearGradient(
                                colors: [Colors.blueGrey, Colors.lightBlue],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/live_dashboard',
                                  arguments: {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    elevation: 1.0,
                                    fillColor: const Color(0xFFF5F6F9),
                                    padding: const EdgeInsets.all(5.0),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/live_dashboard',
                                          arguments: {});
                                    },
                                    child: const Icon(
                                      Icons.dataset_linked_sharp,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const Text('Live Dashboard',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.00,
                      ),
                      Card(
                        elevation: 8.0,
                        child: Ink(
                          width: 150,
                          height: 100,
                          // color: Colors.blue,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.lightBlue, Colors.blueGrey],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/bin_dashboard',
                                  arguments: {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    elevation: 1.0,
                                    fillColor: const Color(0xFFF5F6F9),
                                    padding: const EdgeInsets.all(5.0),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/bin_dashboard',
                                          arguments: {});
                                    },
                                    child: const Icon(
                                      Icons.gas_meter_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const Text('Bin Dashboard',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 8.0,
                        child: Ink(
                          width: 150,
                          height: 100,
                          // color: Colors.blue,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            gradient: const LinearGradient(
                                colors: [Colors.blueGrey, Colors.lightBlue],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/assigned_vehicles',
                                  arguments: {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    elevation: 1.0,
                                    fillColor: const Color(0xFFF5F6F9),
                                    padding: const EdgeInsets.all(5.0),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/assigned_vehicles',
                                          arguments: {});
                                    },
                                    child: const Icon(
                                      Icons.fire_truck_rounded,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const Text('Vehicles',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.00,
                      ),
                      Card(
                        elevation: 8.0,
                        child: Ink(
                          width: 150,
                          height: 100,
                          // color: Colors.blue,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Colors.lightBlue, Colors.blueGrey],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/tasks_list',
                                  arguments: {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RawMaterialButton(
                                    elevation: 1.0,
                                    fillColor: const Color(0xFFF5F6F9),
                                    padding: const EdgeInsets.all(5.0),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/tasks_list',
                                          arguments: {});
                                    },
                                    child: const Icon(
                                      Icons.task,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const Text('Tasks',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // code for bottom nav screen
            ],
          ),
        ],
      )),
    );
  }

// showLoaderDialog(BuildContext context) {
//   AlertDialog alert = AlertDialog(
//     content: new Row(
//       children: [
//         CircularProgressIndicator(),
//         Container(
//             margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
//       ],
//     ),
//   );
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
}
