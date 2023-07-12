import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/AlertsListModel.dart';
import 'package:pcmc_staff/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/WardModel.dart';
import '../models/ZoneModel.dart';
import 'home_supervisor.dart';

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  late String alertID;
  final TextEditingController _remarkUpdateController = TextEditingController();
  List<String> statusList = <String>['New', 'Open', 'Close'];
  String? selectedStatus = 'New';
  final TextEditingController _descriptionController = TextEditingController();

  ZoneModel? selectedZone;
  List<ZoneModel> zones = <ZoneModel>[];

  // for ward dropdown
  WardModel? selectedWard;
  List<WardModel> wards = <WardModel>[];

  late String? userDesignation;
  // we need to populate this list so creating Future function
  Future getAllZoneNames() async {
    Response response = await post(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=ward_list&auth_key=PCMCS56ADDGPIL'));
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);
      // print(jsonDataZones[0]['ward_id']);
      // print(jsonDataZones[0]['ward_name']);
      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          zones.add(ZoneModel(
              ward_id: jsonDataZones[i]['ward_id'].toString(),
              ward_name: jsonDataZones[i]['ward_name'].toString()));
          // zoneNamesList.add(
          //     {jsonDataZones[i]['ward_id'], jsonDataZones[i]['ward_name']});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllZoneNames();
    alertID = '';
    userDesignation = '';
    getUserDetails();
  }

  void getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // staffID = prefs.getString('staffID');
      userDesignation = prefs.getString('designation');
      // print('staffID: $staffID');
      // print('User Designation: $userDesignation');
    });
  }

  Future getAllWardNames(zoneid) async {
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=wards_list&auth_key=PCMCS56ADDGPIL'),
        body: {'zoneid': zoneid});
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataWards = json.decode(response.body);
      setState(() {
        // wardNamesList = jsonDataWards;
        for (int i = 0; i < jsonDataWards.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          wards.add(WardModel(
              wards_id: jsonDataWards[i]['wards_id'].toString(),
              wards_name: jsonDataWards[i]['wards_name'].toString()));
          // zoneNamesList.add(
          //     {jsonDataZones[i]['ward_id'], jsonDataZones[i]['ward_name']});
        }
      });
    }
  }

  Future<List<AlertsListModel>> getAlertsListDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=issue_list&auth_key=PCMCS56ADDGPIL&staff_id=40861'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;

    return data.map((e) => AlertsListModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts"),
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
        actions: [
          RawMaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, '/new_alert', arguments: {});
            },
            elevation: 1.0,
            fillColor: const Color(0xFFF5F6F9),
            padding: const EdgeInsets.all(5.0),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getAlertsListDataFromAPI(),
        builder: (context, data) {
          if (data.hasError) {
            return Text('${data.error}');
          } else if (data.hasData) {
            var items = data.data as List<AlertsListModel>;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        alertID = items[index].issue_id.toString();
                        print(alertID);
                        debugPrint(items[index].image1);
                      });
                      //TODO: ADD UPDATE REMARK FUNCTIONALITY ON TAP
                      updateAlert();

                      // When user clicks on alert from alerts list he can add remark
                      //api: Update Issue Remark
                      // https://pcmc.bioenabletech.com/api/service.php?q=update_issue_remark&auth_key=PCMCS56ADDGPIL&id=140&staff_id=40861&remark_update=Bin Repaired&status=Closed
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Alert/Issue ID: ${items[index].issue_id}'),
                                Text(
                                    'Description: ${items[index].description}'),
                                Text('Raised By: ${items[index].raised_By}'),
                                Text('Employee ID: ${items[index].emp_id}'),
                                Text('Ward ID: ${items[index].ward_id}'),
                                Text('Remark: ${items[index].remark}'),
                                Text('Status: ${items[index].status}'),
                                Text('Created On: ${items[index].created_on}'),
                                // Text('Created On: ${items[index].image1}'),
                                // items[index].image1.toString().startsWith(
                                //             'https://pcmc.bioenabletech.com') ||
                                //         items[index].image1.toString().isEmpty
                                //     ? const Text('Image not available')
                                //     : Image.memory(
                                //         const Base64Decoder().convert(
                                //           items[index].image1.toString(),
                                //         ),
                                //         width: 250,
                                //         height: 50,
                                //       )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void updateRemark(alertId, updatedRemark, updatedStatus) async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=update_issue_remark&auth_key=PCMCS56ADDGPIL'),
        body: {
          'id': alertId,
          'staff_id': staffID,
          'remark_update': updatedRemark,
          'status': updatedStatus,
        });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data[0]['msg'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Update successful')));
        // print('success');
        // stop progress bar
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Alerts();
          // Navigator.pop(context);
        }));
      } else {
        // String resp = data[0]['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
        // print('Update failed');
        Navigator.of(context).pop();
        return;
      }
    }
  }

  updateAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Text(
              "Update Remark",
              style: TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Update Remark",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _remarkUpdateController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Update Remark',
                            labelText: 'Update Remark'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        items: statusList.map((String complaint) {
                          return DropdownMenuItem<String>(
                            value: complaint,
                            child: Text(complaint),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          hintText: 'Select from drop down',
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_remarkUpdateController.text.toString().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('please enter issue remark')));
                            return;
                          }
                          if (selectedStatus!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('please select status')));
                            return;
                          }
                          try {
                            //start progress bar
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            //call method
                            print(alertID);
                            print(_remarkUpdateController.text.toString());
                            print(selectedStatus.toString());

                            updateRemark(
                                alertID,
                                _remarkUpdateController.text.toString(),
                                selectedStatus.toString());
                            //Passing dummy image foe now TODO: change with image selected from camera/gallery

                            //stop progress bar
                            // stop progress bar
                            Navigator.of(context).pop();
                          } catch (e) {
                            // stop progress bar
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text(
                          "Update",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
