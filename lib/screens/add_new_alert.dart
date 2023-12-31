import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
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
  //step 3
  Uint8List? _image;
  Uint8List? _image1;

  // step 1
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  // step 2
  void selectImage() async {
    //
    Uint8List image = await pickImage(ImageSource.camera);
    setState(() {
      _image = image;
      ImagetoBase64();

      print('image size: ${_image!.lengthInBytes}');
    });
  }

  void selectImage1() async {
    //
    Uint8List image = await pickImage(ImageSource.camera);
    setState(() {
      _image1 = image;
      ImagetoBase641();
    });
  }

  String base64String = '';

  ImagetoBase64() async {
    // path of image
    // _selectedProfileImage = MemoryImage(_image!);
    // File _imageFile = File(_selectedProfileImage);
    //
    // // Read bytes from the file object
    // Uint8List _bytes = await _imageFile.readAsBytes();

    // base64 encode the bytes
    String _base64String = base64.encode(_image!);
    setState(() {
      base64String = _base64String;
      compressBase64Image(base64String, 512000);
    });
  }

  String base64String1 = '';

  ImagetoBase641() async {
    // path of image
    // _selectedProfileImage = MemoryImage(_image!);
    // File _imageFile = File(_selectedProfileImage);
    //
    // // Read bytes from the file object
    // Uint8List _bytes = await _imageFile.readAsBytes();

    // base64 encode the bytes
    String _base64String1 = base64.encode(_image1!);
    setState(() {
      base64String1 = _base64String1;
      compressBase64Image1(base64String1, 512000);
    });
  }

  //compress img 1
  var compressedBase64Image = '';
  compressBase64Image(String base64Image, int targetSizeInBytes) async {
    // Decode the Base64 image to bytes
    var imageBytes = base64Decode(base64Image);

    // Compress the image bytes
    var compressedBytes = await FlutterImageCompress.compressWithList(
      imageBytes,
      minHeight:
          1920, // Set the desired height and width of the compressed image
      minWidth: 1080,
      quality: 80, // Set the quality of the compressed image (0-100)
    );

    // Check if the compressed image size is already within the target size
    if (compressedBytes.lengthInBytes <= targetSizeInBytes) {
      // If the compressed image is smaller than or equal to the target size, return the Base64 representation
      setState(() {
        compressedBase64Image = base64Encode(compressedBytes);
      });
      // return base64Encode(compressedBytes);
    } else {
      // If the compressed image is larger than the target size, recursively compress it further
      compressBase64Image(base64Encode(compressedBytes), targetSizeInBytes);
    }
  }

  //compress img 2
  var compressedBase64Image1 = '';
  compressBase64Image1(String base64Image, int targetSizeInBytes) async {
    // Decode the Base64 image to bytes
    var imageBytes = base64Decode(base64Image);

    // Compress the image bytes
    var compressedBytes = await FlutterImageCompress.compressWithList(
      imageBytes,
      minHeight:
          1920, // Set the desired height and width of the compressed image
      minWidth: 1080,
      quality: 80, // Set the quality of the compressed image (0-100)
    );

    // Check if the compressed image size is already within the target size
    if (compressedBytes.lengthInBytes <= targetSizeInBytes) {
      // If the compressed image is smaller than or equal to the target size, return the Base64 representation
      setState(() {
        compressedBase64Image1 = base64Encode(compressedBytes);
      });
      // return base64Encode(compressedBytes);
    } else {
      // If the compressed image is larger than the target size, recursively compress it further
      compressBase64Image(base64Encode(compressedBytes), targetSizeInBytes);
    }
  }

  final TextEditingController _descriptionController = TextEditingController();

  ZoneModel? selectedZone;
  List<ZoneModel> zones = <ZoneModel>[];

  // for ward dropdown
  WardModel? selectedWard;
  List<WardModel> wards = <WardModel>[];

  late String? staffID;
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
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    staffID = '';
    userDesignation = '';

    getAllZoneNames();
    getUserDetails();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () =>
              Navigator.pop(context, MaterialPageRoute(builder: (context) {
            return const Alerts();
            // Navigator.pop(context);
          })),
        ),
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
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
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
                      : Image.memory(
                          _image!,
                          height: 150,
                          width: 200,
                        ),
                  const SizedBox(width: 16.0),
                  InkWell(
                    child: RawMaterialButton(
                      onPressed: () async {
                        var status = await Permission.camera.status;
                        if (!status.isGranted) {
                          await Permission.camera.request();
                        }
                        selectImage();
                      },
                      elevation: 2.0,
                      fillColor: const Color(0xFFF5F6F9),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () async {
                      var status = await Permission.camera.status;
                      if (!status.isGranted) {
                        await Permission.camera.request();
                      }
                      selectImage();

                      // getImage1();
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
                      : Image.memory(
                          _image1!,
                          height: 150,
                          width: 200,
                        ),
                  const SizedBox(width: 16.0),
                  InkWell(
                    child: RawMaterialButton(
                      onPressed: () async {
                        var status = await Permission.camera.status;
                        if (!status.isGranted) {
                          await Permission.camera.request();
                        }
                        selectImage1();
                      },
                      elevation: 2.0,
                      fillColor: const Color(0xFFF5F6F9),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () async {
                      var status = await Permission.camera.status;
                      if (!status.isGranted) {
                        await Permission.camera.request();
                      }
                      selectImage1();

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
                        Navigator.pop(
                          context,
                          '/alerts',
                        );
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
                          //start progress bar
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              });

                          // call api method
                          addIssue(
                              staffID,
                              _descriptionController.text.toString(),
                              selectedZone!.ward_id.toString(),
                              selectedIssue,
                              '18.51410791',
                              '73.92358895',
                              compressedBase64Image,
                              compressedBase64Image1,
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
        Navigator.pop(context, MaterialPageRoute(builder: (context) {
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

  void getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      staffID = prefs.getString('staffID');
      userDesignation = prefs.getString('designation');
      // print('staffID: $staffID');
      // print('User Designation: $userDesignation');
    });
  }
}
