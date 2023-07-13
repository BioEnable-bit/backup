import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/WardModel.dart';
import '../models/ZoneModel.dart';

class AddFollowUp extends StatefulWidget {
  const AddFollowUp({super.key});

  @override
  State<AddFollowUp> createState() => _AddFollowUpState();
}

class _AddFollowUpState extends State<AddFollowUp> {
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  List<String> statusList = <String>['New', 'Open', 'Close'];
  String? selectedStatus = 'New';
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

  ZoneModel? selectedZone;
  List<ZoneModel> zones = <ZoneModel>[];

  // for ward dropdown
  WardModel? selectedWard;
  List<WardModel> wards = <WardModel>[];

  late String? staffID;
  late String? userDesignation;

  // we need to populate this list so creating Future function

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskID = ModalRoute.of(context)!.settings.arguments as String;
    print('args: $taskID');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Follow Up"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pushReplacementNamed(
                context, '/tasks_list',
                arguments: {})),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _remarkController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add Remark',
                      labelText: 'Add Remark'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _urlController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add Url',
                      labelText: 'Add Url'),
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        //
                        Navigator.pushReplacementNamed(context, '/tasks_list',
                            arguments: {});
                      },
                      child: const Text('Cancel')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_remarkController.text.toString().isEmpty ||
                            _urlController.text.toString().isEmpty ||
                            selectedStatus.toString().isEmpty) {
                          return;
                        }
                        try {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          //TODO: ADD IMAGE FILE UPLOAD FEATURE
                          addFollowUpAPICall(
                              _remarkController.text.toString(),
                              compressedBase64Image,
                              _urlController.text.toString(),
                              selectedStatus.toString(),
                              taskID);
                        } catch (e) {
                          String err = e.toString();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('error: $err')));
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

  void addFollowUpAPICall(
      remark, snapshot, url, task_status, selectedTaskID) async {
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=add_followup&auth_key=PCMCS56ADDGPIL'),
        body: {
          'task_id': selectedTaskID,
          'remark': remark,
          'snapshot': snapshot,
          'url': url,
          'task_status': task_status,
        });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      if (data[0]['msg'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Follow up added successfully')));
        // stop progress bar
        Navigator.of(context).pop();

        // close current alert box
        Navigator.pop(context);
      } else if (data == []) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Internal Server Error')));
        // stop progress bar
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Follow up failed')));
        // stop progress bar
        Navigator.of(context).pop();
        return;
      }
    }
  }
}
