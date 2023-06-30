import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/ProfileDataModel.dart';

import 'home.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

// Update profile will be an alert box
class _ProfileState extends State<Profile> {
  late String staffID;

  Future<List<ProfileDataModel>> getUserDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=show_profile&auth_key=PCMCS56ADDGPIL&staff_id=$staffID'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    return data.map((e) => ProfileDataModel.fromJson(e)).toList();
  }

  @override
  void initState() {
    staffID = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get data shared with Navigator.pushNamed
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    // Assign value to staffID
    //NOTE: staffID from login and empNo from profile api are same
    staffID = arguments['staffID'];
    return Container(
      // decoration not working
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white, Color(0xffe6f9ff)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const Home();
              // Navigator.pop(context);
            })),
          ),
          title: const Text("Profile"),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getUserDataFromAPI(),
            builder: (context, data) {
              if (data.hasError) {
                return Text('${data.error}');
              } else if (data.hasData) {
                var items = data.data as List<ProfileDataModel>;
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card for Profile Image and Text
                      Card(
                        margin: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  //TODO: Set Image Received from profile api
                                  // items[0].photo.toString()
                                  image: AssetImage(
                                      'assets/image_placeholder.png'))),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(items[0].staffname.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                                const SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                  // alignment: Alignment(200, 0),
                                  onPressed: () {
                                    print('clicked');
                                    //TODO: OPEN EDIT PROFILE SCREEN ON ICON TAP
                                  },
                                  icon: const Icon(
                                    // creating the first icon.
                                    Icons.edit,
                                    // size: size.width * .06,
                                    size: 25,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                //
                                const Icon(
                                  // creating the first icon.
                                  Icons.phone_android,
                                  // size: size.width * .06,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(items[0].mobile.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                //
                                const Icon(
                                  // creating the first icon.
                                  Icons.email_outlined,
                                  // size: size.width * .06,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(items[0].empid.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                //
                                const Icon(
                                  // creating the first icon.
                                  Icons.home,
                                  // size: size.width * .06,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(items[0].address.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                //
                                const Icon(
                                  // creating the first icon.
                                  Icons.work,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(items[0].department.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                //
                                const Icon(
                                  // creating the first icon.
                                  Icons.work_outline,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(items[0].designation.toString()),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // ElevatedButton(
                            //     onPressed: () {
                            //       //TODO: OPEN UPDATE PROFILE ALERT BOX
                            //     },
                            //     child: const Text('Update Profile')),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
