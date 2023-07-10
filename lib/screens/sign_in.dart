import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/Designation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignIn> {
  bool ActiveConnection = false;

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;

          print('internet');
        });
      }
    } on SocketException catch (e) {
      print(e.toString());
      setState(() {
        ActiveConnection = false;
        print('no internet');
        ShowAlertDialog(context);
      });
    }
  }

  ShowAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        checkUserConnection();
        getAlldesigNames();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("No Internet Connection"),
      content:
          const Text("Switch on your device internet connection to continue"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _mobileNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  Designation? selectedDesignation;

  List<Designation> zones = <Designation>[];
  Future getAlldesigNames() async {
    Response response = await get(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=masters&auth_key=PCMCS56ADDGPIL&type=desig'));
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);
      // print(jsonDataZones.toString());
      // print(jsonDataZones[0]['designation']);
      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          zones.add(Designation(
              desig_id: jsonDataZones[i]['id'].toString(),
              desig_name: jsonDataZones[i]['designation'].toString()));
          // zoneNamesList.add(
          //     {jsonDataZones[i]['ward_id'], jsonDataZones[i]['ward_name']});
        }
      });
    }
  }

  @override
  void initState() {
    getAlldesigNames();
    checkUserConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white, Color(0xffe6f9ff)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft),
      ),
      // image: DecorationImage(
      //     image: AssetImage('assets/whitebg.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 2),shape: BoxShape.circle),
                      //
                      // child: const Icon(Icons.person,color: Colors.white,size: 90,),

                      padding: const EdgeInsets.only(left: 35, top: 120),
                      child: const Text(
                        'Welcome To \n PCMC Staff',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.40,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          //icon: Icon(Icons.mobile_friendly_rounded),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Enter Mobile Number',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: _mobileNumberController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = RegExp(patttern);
                        if (value.isEmpty) {
                          return 'Please enter mobile number';
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid mobile number(0-9)';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          //icon: Icon(Icons.password_rounded),
                          filled: true,
                          hintText: 'Enter Your Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,

                          // border: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(10))),//background color of dropdown button
                          // border: Border.all(color: Colors.black, width:0), //border of dropdown button
                          borderRadius: BorderRadius.circular(
                              10), //border raiuds of dropdown button
                          boxShadow: <BoxShadow>[
                            //apply shadow on Dropdown button
                            BoxShadow(
                                color: Color.fromRGBO(
                                    0, 0, 0, 0.57), //shadow for button
                                blurRadius: 6) //blur radius of shadow
                          ]),
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, right: 30),
                        child: DropdownButton<Designation>(
                          hint: const Text("Select a Designation"),
                          value: selectedDesignation,
                          onChanged: (Designation? newValue) {
                            setState(() {
                              selectedDesignation = newValue!;
                              print(selectedDesignation.toString());

                              // getAlldesigNames();
                              // getAlldesigNames(selectedDesignation?.desig_id.toString());
                            });
                            // print(zones.indexOf(newValue!));
                          },
                          items: zones.map((Designation zoneModel) {
                            return DropdownMenuItem<Designation>(
                              value: zoneModel,
                              child: Text(
                                zoneModel.desig_name.toString(),
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SignIn',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff2E5456),
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () async {
                              // show progress bar

                              String mobile = _mobileNumberController.text;
                              String password = _passwordController.text;
                              String? designation =
                                  selectedDesignation?.desig_id.toString();
                              print('###################');
                              print(password);
                              print(mobile);
                              print(designation);
                              print(selectedDesignation?.desig_id.toString());
                              // userAuth(mobile, password);
                              print('OutPPUT');
                              print(designation);
                              if (mobile.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Enter Your Mobile Number')));
                                return;
                              } else if (password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Enter Your PassWord')));
                                return;
                              } else if (selectedDesignation == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Select Your Designation')));
                                return;
                              } else if (mobile != "" && password != "") {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    });

                                try {
                                  Response response = await post(
                                      Uri.parse(
                                          'https://pcmc.bioenabletech.com/api/service.php?q=staff_login&auth_key=PCMCS56ADDGPIL'),
                                      body: {
                                        'mobile': mobile,
                                        'password':
                                            password, //category is complaint selected by user
                                        'designation': designation,
                                      });
                                  // stop progress bar
                                  Navigator.of(context).pop();

                                  //check
                                  if (response.statusCode == 200) {
                                    var data =
                                        jsonDecode(response.body.toString());
                                    if (data[0]['msg'] == 'success') {
                                      print(
                                          'Designation: ${data[0]['designation']}');
                                      _saveLogindata(
                                          data[0]['staffID'],
                                          data[0]['WardID'],
                                          data[0]['designation']);
                                      // Passing Intent to home screen
                                      // save customer ID and Ward ID to Shared Preference
                                      _saveDataToPrefs(
                                        mobile,
                                        password,
                                        designation,
                                        // data[0]['customerID'],
                                        // data[0]['WardID']
                                      );
                                      // intent pass
                                      // Navigator.pop(context);
                                      data[0]['designation'] == "Driver"
                                          ? Navigator.pushReplacementNamed(
                                              context, '/home', arguments: {
                                              'staffID': data[0]['staffID'],
                                              'WardID': data[0]['WardID'],
                                              'designation': data[0]
                                                  ['designation'],
                                            })
                                          : Navigator.pushReplacementNamed(
                                              context, '/home_supervisor',
                                              arguments: {
                                                  'staffID': data[0]['staffID'],
                                                  'WardID': data[0]['WardID'],
                                                  'designation': data[0]
                                                      ['designation'],
                                                });

                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (context) {
                                      //       return const Home();
                                      //     }));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Successfully Login'),
                                        backgroundColor: Color(0xFF23E06F),
                                        duration: Duration(milliseconds: 3000),
                                        animation: AlwaysStoppedAnimation(
                                            BorderSide.strokeAlignCenter),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Invalid Credentials'),
                                        backgroundColor: Color(0xFFEE2E22),
                                        duration: Duration(milliseconds: 3000),
                                        animation: AlwaysStoppedAnimation(
                                            BorderSide.strokeAlignCenter),
                                      ));
                                    }
                                  }
                                } catch (e) {
                                  String err = e.toString();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(err)));
                                  Navigator.of(context).pop();
                                }
                                return;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Enter details to login')));
                                return;
                              }
                            },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(context,
                        //         MaterialPageRoute(builder: (context) {
                        //           return const SignUpScreen();
                        //           // Navigator.pop(context);
                        //         }));
                        //   },
                        //   child: const Text(
                        //     'SignUp',
                        //     style: TextStyle(
                        //       color: Color(0xff4c505b),
                        //       fontSize: 17,
                        //       fontWeight: FontWeight.w700,
                        //     ),
                        //   ),
                        // ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ForgotPassword();
                              // Navigator.pop(context);
                            }));
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Color(0xff4c505b),
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _saveDataToPrefs(mobile, password, designation) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('mobile', mobile);
  await prefs.setString('password', password);
  await prefs.setString('designation', designation);

  // await prefs.setString('isSignedIn', 'true');
}

// void registerUser(fname, lname, email, mobile, password, zoneid, wardsid,
//     address, context) async {
//   try {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         });
//     Response response = await post(
//         Uri.parse(
//             'https://pcmc.bioenabletech.com/api/service.php?q=staff_login&auth_key=PCMCS56ADDGPIL'),
//         body: {
//           'mobile': fname,
//           'password': lname, //category is complaint selected by user
//           'designation': email,
//
//         });
//     //check
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body.toString());
//       if (data[0]['msg'] == 'success') {
//         _saveLogindata(data[0]['staffid'],
//             data[0]['wardId'],
//             data[0]['designation']);
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Registration successful')));
//
//         // stop progress bar
//         Navigator.of(context).pop();
//         // Passing Intent to home screen
//         Navigator.pushReplacementNamed(context, '/home', arguments: {
//
//
//         });
//         // Navigator.pushReplacement(context as BuildContext,
//         //     MaterialPageRoute(builder: (context) {
//         //       return const Home();
//         //     }));
//       } else if (data[0]['msg'] == 'wrong password') {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//             content: Text('please Enter Valid Mobile Number And Password')));
//         Navigator.of(context).pop();
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) {
//               return const Home();
//               // Navigator.pop(context);
//             }));
//         return;
//       } else {
//         Navigator.of(context).pop();
//         return;
//       }
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Registration failed')));
//     Navigator.of(context).pop();
//     // ScaffoldMessenger.of(context)
//     //     .showSnackBar(SnackBar(content: Text('Authentication failed')));
//   }
// }
Future<void> _saveLogindata(staffid, wardId, designation) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('staffID', staffid);
  await prefs.setString('WardID', wardId);
  await prefs.setString('designation', designation);

  // await prefs.setString('isSignedIn', 'true');
}
