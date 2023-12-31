import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcmc_staff/screens/profile.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/ProfileDataModel.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  //step 3
  Uint8List? _image;

  // var _selectedProfileImage;
  // step 1
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    // setState(() {
    //   _selectedProfileImage = _file;
    // });
    print('No Image Selected');
  }

  // step 2
  void selectImage() async {
    //
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
      ImagetoBase64();

      //call function to convert in base64
      // List<int> imageBytes = _selectedProfileImage.readAsBytesSync();
      // print('imageBytes : $imageBytes');
      // String base64Image = base64Encode(imageBytes);
      // print('base64Image: $base64Image');
      // print(_selectedProfileImage);
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
    });
  }

  //
  getFromGallery(context) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
    } catch (e) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        showAlertDialog(context);
      } else {
        print('exception: ${e.toString()}');
      }
    }
  }

  Future<List<ProfileDataModel>> getUserDataFromAPI() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    Response response = await get(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=show_profile&auth_key=PCMCS56ADDGPIL&staff_id=$staffID'));
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    print(data);
    String fullName = data[0]['staffname'];
    var nameList = fullName.split(' ');
    print("nameList : $nameList");
    print("fName: " + nameList[0]);
    print("lName: " + nameList[1]);

    setState(() {
      employeeID = data[0]['empid'];

      oldFName = nameList[0];
      oldLName = nameList[1];
      oldEmail = data[0]['email'];
      oldMobile = data[0]['mobile'];
      oldAddress = data[0]['address'];
      oldPhotoBase64 = data[0]['photo'];

      // debugPrint(base64String);
    });
    return data.map((e) => ProfileDataModel.fromJson(e)).toList();
  }

  // UserDataModel currentUser = UserDataModel.fromJson(json);
  @override
  void initState() {
    employeeID = '';

    oldFName = '';

    oldPhotoBase64 = '';

    oldLName = '';

    oldMobile = '';

    oldEmail = '';

    oldAddress = '';

    getUserDataFromAPI();

    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  late String employeeID; //employeeID and staffID are same

  late String oldFName;
  late String oldPhotoBase64;
  TextEditingController _fnameController = TextEditingController();
  late String oldLName;
  final TextEditingController _lnameController = TextEditingController();
  // late String oldPassword;
  final TextEditingController _passwordController = TextEditingController();
  late String oldEmail;
  final TextEditingController _emailController = TextEditingController();
  late String oldMobile;
  final TextEditingController _mobileController = TextEditingController();
  late String oldAddress;
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  void _clearButton() {
    _fnameController.clear();
    _lnameController.clear();
    _emailController.clear();
    _mobileController.clear();
    _passwordController.clear();
    _addressController.clear();
  }

  void _submitForm() {}

  @override
  Widget build(BuildContext context) {
    _fnameController.text = oldFName;

    _lnameController.text = oldLName;

    _mobileController.text = oldMobile;

    _emailController.text = oldEmail;

    _addressController.text = oldAddress;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Profile();
            // Navigator.pop(context);
          })),
        ),
        title: const Text("Update Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      // image api -> show
                      _image == null
                          ? Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 200,
                                    child: ClipOval(
                                      child: oldPhotoBase64 != ''
                                          ? Image.memory(
                                              const Base64Decoder().convert(
                                                oldPhotoBase64,
                                              ),
                                            )
                                          : Image.asset('assets/profile.png'),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        selectImage();
                                        // _selectedProfileImage = MemoryImage(_image!);
                                        // print(
                                        //     '_selectedProfileImage : $_selectedProfileImage');
                                        //TODO: ADD SELECT NEW IMAGE FUNCTIONALITY ON BUTTON TAP
                                      },
                                      elevation: 2.0,
                                      fillColor: const Color(0xFFF5F6F9),
                                      padding: const EdgeInsets.all(5.0),
                                      shape: const CircleBorder(),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: Image.memory(
                                      _image!,
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        selectImage();
                                        // _selectedProfileImage = MemoryImage(_image!);
                                        // print(
                                        //     '_selectedProfileImage : $_selectedProfileImage');
                                      },
                                      elevation: 2.0,
                                      fillColor: const Color(0xFFF5F6F9),
                                      padding: const EdgeInsets.all(5.0),
                                      shape: const CircleBorder(),
                                      child: const Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                // Row(
                //   children: [
                //     Image.asset(
                //
                //       'assets/image_placeholder.png',
                //       height: 150,
                //       width: 200,
                //     ),
                //
                //     // : Image.file(
                //     //     _image,
                //     //     height: 150,
                //     //     width: 200,
                //     //   ),
                //     const SizedBox(width: 16.0),
                //     InkWell(
                //       child: const Icon(
                //         Icons.photo_camera_back,sign
                //         size: 50,
                //       ),
                //       onTap: () async {
                //         var status = await Permission.camera.status;
                //         if (!status.isGranted) {
                //           await Permission.camera.request();
                //         }
                //         // getImage();
                //         // //compress image2 base64 String
                //         // compressBase64Image1(base64String1, 512000);
                //       },
                //     )
                //   ],
                // ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _fnameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter First Name'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _lnameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Last Name'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Enter Email'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _mobileController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Mobile'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    maxLines: null,
                    controller: _addressController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter Address'),
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () {
                    // ImagetoBase64();
                    // print(base64String);
                    if (_fnameController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('please enter first name')));
                      return;
                    }
                    if (_lnameController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('please enter last name')));
                      return;
                    }
                    if (_emailController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('please enter email')));
                      return;
                    }
                    if (_mobileController.text == "" ||
                        _mobileController.text.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('please enter mobile')));
                      return;
                    }

                    if (_addressController.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('please enter proper address')));
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
                      //Passing dummy image foe now TODO: change with image selected from camera/gallery
                      editProfile(
                          _fnameController.text.toString(),
                          _lnameController.text.toString(),
                          _mobileController.text.toString(),
                          _emailController.text.toString(),
                          _addressController.text.toString(),
                          base64String);
                      //stop progress bar
                      // stop progress bar
                      Navigator.of(context).pop();
                    } catch (e) {
                      // stop progress bar
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editProfile(firstName, lastName, mobile, email, address, photo) async {
    // final prefs = await SharedPreferences.getInstance();
    // var staffID = prefs.getString('staffID');
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?auth_key=PCMCS56ADDGPIL&q=update_profile'),
        body: {
          'staff_id': employeeID,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'mobile': mobile,
          'permanent_address': address,
          'photo': photo,
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
          return const Profile();
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

  FlatButton({required Text child, required Null Function() onPressed}) {}

  void showAlertDialog(context) {
    print('access denied');
  }
}
