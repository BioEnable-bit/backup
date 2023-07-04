import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/AlertsListModel.dart';
import 'package:pcmc_staff/screens/home.dart';

import '../models/WardModel.dart';
import '../models/ZoneModel.dart';

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  final TextEditingController _descriptionController = TextEditingController();

  ZoneModel? selectedZone;
  List<ZoneModel> zones = <ZoneModel>[];

  // for ward dropdown
  WardModel? selectedWard;
  List<WardModel> wards = <WardModel>[];
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

  List<String> issueList = <String>[
    'Parking',
    'Traffic',
    'Weather',
    'Water Clogging',
    'Missing/Broken Lid',
    'Leaking Container',
    'Breakdown',
    'Mixed Hazardous Waste',
    'Vehicle Downtime',
    'Blocked Bins / Illegal Parking',
    'Bin Repair',
    'Staff Absent',
    'Non-Availability Of Premise Owner',
    'Premise Owner Not Available'
  ];
  String? selectedIssue = 'Parking';

  Future<List<AlertsListModel>> getTasksListDataFromAPI() async {
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box, color: Colors.blueGrey),
            onPressed: () {
              // TODO: Add Alerts popup functionality

              Navigator.pushNamed(context, '/new_alert', arguments: {});
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getTasksListDataFromAPI(),
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
                      //TODO: ADD UPDATE REMARK FUNCTIONALITY ON TAP
                      // addAlertUpAlert();
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

  addAlertUpAlert() {
    getAllZoneNames();
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
              "Add Alert",
              style: TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              height: 600,
              width: 400,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Select an zone'),
                    DropdownButton<ZoneModel>(
                      hint: const Text("Select a zone"),
                      value: selectedZone,
                      onChanged: (ZoneModel? newValue) {
                        setState(() {
                          selectedZone = newValue;
                          getAllWardNames(selectedZone?.ward_id.toString());
                        });
                        // print(zones.indexOf(newValue!));
                      },
                      items: zones.map((ZoneModel zoneModel) {
                        return DropdownMenuItem<ZoneModel>(
                          value: zoneModel,
                          child: Text(
                            zoneModel.ward_name.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(1.0),
                      child: DropdownButton<ZoneModel>(
                        hint: const Text("Select a zone"),
                        value: selectedZone,
                        onChanged: (ZoneModel? newValue) {
                          setState(() {
                            selectedZone = newValue;
                            getAllWardNames(selectedZone?.ward_id.toString());
                          });
                          // print(zones.indexOf(newValue!));
                        },
                        items: zones.map((ZoneModel zoneModel) {
                          return DropdownMenuItem<ZoneModel>(
                            value: zoneModel,
                            child: Text(
                              zoneModel.ward_name.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(1.0),
                      child: DropdownButton<WardModel>(
                        hint: const Text("Select a ward"),
                        value: selectedWard,
                        onChanged: (WardModel? newValue) {
                          setState(() {
                            selectedWard = newValue;
                          });
                          // print('selected ward index: ' +
                          //     wards.indexOf(newValue!).toString());
                        },
                        items: wards.map((WardModel wardModel) {
                          return DropdownMenuItem<WardModel>(
                            value: wardModel,
                            child: Text(
                              wardModel.wards_name.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: const EdgeInsets.all(1.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Select a issue"),
                        value: selectedIssue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedIssue = newValue;
                          });
                          // print('selected ward index: ' +
                          //     wards.indexOf(newValue!).toString());
                        },
                        items: issueList.map((String newValue) {
                          return DropdownMenuItem<String>(
                            value: newValue,
                            child: Text(
                              newValue,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add Remark',
                            labelText: 'Add Remark'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      // child: Row(
                      //   children: [
                      //     _image == null
                      //         ? Image.asset(
                      //             'assets/image_placeholder.png',
                      //             height: 100,
                      //             width: 150,
                      //           )
                      //         : Image.file(
                      //             _image!,
                      //             height: 100,
                      //             width: 150,
                      //           ),
                      //     // Image.asset('assets/pick_image.png',
                      //     //     height: 150, width: 200),
                      //     const SizedBox(width: 5),
                      //     InkWell(
                      //       child: const Icon(
                      //         Icons.camera_alt,
                      //         size: 30,
                      //       ),
                      //       onTap: () async {
                      //         var status = await Permission.camera.status;
                      //         if (!status.isGranted) {
                      //           await Permission.camera.request();
                      //         }
                      //         //TODO: SELECT IMAGE FROM CAMERA
                      //         // getImage();
                      //       },
                      //     )
                      //   ],
                      // ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          try {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            // TODO: ADD ALERT/Issue API CALL
                          } catch (e) {
                            String err = e.toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: $err')));
                          }
                        },
                        child: const Text(
                          "Add Follow Up",
                        ),
                      ),
                    ),

                    //Issue Type
                  ],
                ),
              ),
            ),
          );
        });
  }
}
