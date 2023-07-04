import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/screens/alerts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/WardModel.dart';
import '../models/ZoneModel.dart';

class AddNewAlert extends StatefulWidget {
  const AddNewAlert({super.key});

  @override
  State<AddNewAlert> createState() => _AddNewAlertState();
}

class _AddNewAlertState extends State<AddNewAlert> {
  final TextEditingController _descriptionController = TextEditingController();

  ZoneModel? selectedZone;
  List<ZoneModel> zones = <ZoneModel>[];

  // for ward dropdown
  WardModel? selectedWard;
  List<WardModel> wards = <WardModel>[];

  late String? staffID;

  var _image;
  var _image1;
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
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    staffID = '';

    getAllZoneNames();
    getStaffID();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Alert"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Select a zone: '),
                  const SizedBox(
                    width: 20,
                  ),
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Select an ward: '),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton<WardModel>(
                    hint: const Text("Select an ward"),
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
                ],
              ),
              Row(
                children: [
                  const Text('Issue: '),
                  const SizedBox(
                    width: 15,
                  ),
                  DropdownButton<String>(
                    hint: const Text("Select an issue"),
                    value: selectedIssue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedIssue = newValue;
                      });
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
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description',
                      labelText: 'Description'),
                ),
              ),
              Row(
                children: [
                  _image == null
                      ? Image.asset(
                          'assets/image_placeholder.png',
                          height: 150,
                          width: 200,
                        )
                      : Image.file(
                          _image!,
                          height: 150,
                          width: 200,
                        ),
                  // Image.asset('assets/pick_image.png',
                  //     height: 150, width: 200),
                  const SizedBox(width: 16.0),
                  InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      size: 50,
                    ),
                    onTap: () async {
                      //permission handler package
                      var status = await Permission.camera.status;
                      if (!status.isGranted) {
                        await Permission.camera.request();
                      }
                      // getImage();
                    },
                  )
                ],
              ),
              Row(
                children: [
                  _image1 == null
                      ? Image.asset(
                          'assets/image_placeholder.png',
                          height: 150,
                          width: 200,
                        )
                      : Image.file(
                          _image1!,
                          height: 150,
                          width: 200,
                        ),
                  const SizedBox(width: 16.0),
                  InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      size: 50,
                    ),
                    onTap: () async {
                      var status = await Permission.camera.status;
                      if (!status.isGranted) {
                        await Permission.camera.request();
                      }

                      // getImage1();
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //
                        Navigator.pushNamed(context, '/alerts', arguments: {});
                      },
                      child: const Text('Cancel')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                        if (selectedZone == null ||
                            selectedWard == null ||
                            selectedIssue.toString().isEmpty ||
                            _descriptionController.text.toString().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Invalid or empty input')));
                          // stop progress bar
                          Navigator.of(context).pop();

                          return;
                        }
                        // print all value
                        print('Zone id: ${selectedZone!.ward_id.toString()}');
                        print('Ward id: ${selectedWard!.wards_id.toString()}');
                        print('Issue: ${selectedIssue.toString()}');
                        print(
                            'description: ${_descriptionController.text.toString()}');
                        // print('image1: ${}');
                        // print('image2: ${}');
                        try {
                          // show progress bar

                          // call api method
                          addIssue(
                              staffID,
                              _descriptionController.text.toString(),
                              selectedZone!.ward_id.toString(),
                              selectedIssue,
                              '18.51410791',
                              '73.92358895',
                              '',
                              '',
                              selectedWard!.wards_id
                                  .toString()); //Issue and Alerts are same
                          // stop progress bar
                          Navigator.of(context).pop();
                        } catch (e) {
                          print('error: ${e.toString()}');
                          // stop progress bar
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addIssue(staff_id, description, ward_id, issue_type, latitude, longitude,
      image1, image2, wardid) async {
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=add_issue&auth_key=PCMCS56ADDGPIL'),
        body: {
          'staff_id': staff_id,
          'description': description,
          'ward_id': ward_id,
          'issue_type': issue_type,
          'latitude': latitude,
          'longitude': longitude,
          'image1': image1,
          'image2': image2,
          'longitude': longitude,
          'wardid': wardid,
        });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data[0]['msg'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Issue added successfully')));
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

  void getStaffID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      staffID = prefs.getString('staffID');
      print('staffID: $staffID');
    });
  }
}
