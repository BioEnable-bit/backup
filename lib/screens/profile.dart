import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/ProfileDataModel.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

// Update profile will be an alert box
class _ProfileState extends State<Profile> {
  Future<List<ProfileDataModel>> getUserDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    //TODO: PASS staff_id to api
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=show_profile&auth_key=PCMCS56ADDGPIL&staff_id=40861'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    return data.map((e) => ProfileDataModel.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder(
        future: getUserDataFromAPI(),
        builder: (context, data) {
          if (data.hasError) {
            return Text('${data.error}');
          } else if (data.hasData) {
            var items = data.data as List<ProfileDataModel>;
            return Center(
              child: Column(
                children: [
                  Text(items[0].staffname.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                  Text('Mobile: ' + items[0].mobile.toString()),
                  Text('Email: ' + items[0].email.toString()),
                  // Text('Ward Name: ' + items[0].ward_name.toString()),
                  // Text('Ward Office: ' + items[0].ward_office.toString()),
                  // Text('Customer ID: ' + items[0].custid.toString()),
                  // Text('address: ' + items[0].address.toString()),
                  ElevatedButton(
                      onPressed: () {
                        //TODO: OPEN UPDATE PROFILE ALERT BOX
                      },
                      child: const Text('Update Profile')),
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
    );
  }
}
