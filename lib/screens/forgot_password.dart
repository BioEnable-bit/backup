
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

//import 'package:pcmc_citizen_app_flutter/screens/sign_in_screen.dart';

import 'package:pcmc_staff/screens/sign_in.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPassword> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  late String userMobile;
  @override
  void initState() {
    userMobile = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {

                return const SignIn();
                // Navigator.pop(context);
              })),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Forgot Password'),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Forgot Password',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Enter your mobile number that you used to create an account in PCMC Citizen app:',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _mobileNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                print('clicked');
                userMobile = _mobileNumberController.text.toString();
                if (_mobileNumberController.text.toString() == '') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Enter correct mobile number')));
                  return;
                }
                if (_mobileNumberController.text.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wrong Mobile Number.., Please enter your correct mobile number')));
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
                  print('try send otp');
                  String mobile = _mobileNumberController.text.toString();
                  sendOTPOnEmail(mobile);
                } catch (e) {
                  String err = e.toString();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('error: $err')));
                }
                // stop progress bar

                // String mobileNumber = _mobileNumberController.text;
                // resetPassword(mobileNumber, context);
                //
                // // Perform password reset logic here
                //
                // // Implement your password reset functionality
                // // using the provided mobile number

                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     return AlertDialog(
                //       title: const Text('Password Reset'),
                //       content: Text(
                //         'Password reset instructions have been sent to $mobileNumber.',
                //       ),
                //       actions: const [
                //         // FlatButton(
                //         //   child: Text('OK'),
                //         //   onPressed: () {
                //         //     Navigator.pop(context);
                //         //   },
                //         // ),
                //       ],
                //     );
                //   },
                // );
              },
              child: const Text('Send OTP on email'),
            ),
          ],
        ),

            const SignIn();
            // Navigator.pop(context);
          })),
        ),
        title: const Text("Forgot Password"),

      ),
    );
  }

  Future<void> sendOTPOnEmail(mobile) async {
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=otp_send&auth_key=PCMCS56ADDGPIL'),
        body: {
          "mobile": mobile,
        });
    if (response.statusCode == 200) {
      print('code: 200');

      var data = jsonDecode(response.body.toString());

      if (data['result'] == 'You are not register in this application') {
        print('failed to send OTP');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('failed to send OTP')));
        // stop progress bar
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('OTP sent')));
        // stop progress bar
        Navigator.of(context).pop();
        ShowEnterOTPAlert();
      }
    }
  }

  Future<void> resetPassword(newPassword) async {
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=reset_pwd&auth_key=PCMCS56ADDGPIL'),
        body: {
          "mobile": userMobile,
          "pwd": newPassword,
          "type": 'staff',
        });
    if (response.statusCode == 200) {
      print('code: 200');

      var data = jsonDecode(response.body.toString());
      print(data['result']);
      if (data['result'] == 'Password is changed successful...') {
        print('Password Changed Successfully');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Changed Successfully')));
        // stop progress bar
        Navigator.of(context).pop();
        // close current alert box
        Navigator.pop(context);
        //Intent to Login
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return const SignIn();
              // Navigator.pop(context);
            }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset failed')));
        // stop progress bar
        Navigator.of(context).pop();
      }
    }
  }

  ShowEnterOTPAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: 10.0,
            ),
            title: Text(
              "Enter OTP",
              style: TextStyle(fontSize: 24.0),
            ),
            content: Container(
              height: 400,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Enter OTP ",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter OTP here',
                            labelText: 'OTP'),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_otpController.text.length != 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Incomplete OTP')));
                            return;
                          }
                          // Navigator.of(context).pop();
                          try {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });

                            String otp = _otpController.text.toString();

                            verifyOTP(otp, userMobile);
                          } catch (e) {
                            String err = e.toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: $err')));
                          }
                          //TODO: Pass OTP Here
                        },
                        child: const Text(
                          "Verify OTP",
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text('Note'),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt'
                    //     ' ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud'
                    //     ' exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
                    //     ' Duis aute irure dolor in reprehenderit in voluptate velit esse cillum '
                    //     'dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,'
                    //     ' sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    //     style: TextStyle(fontSize: 12),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showResetPasswordAlert() {
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
              "Reset Password",
              style: TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              height: 400,
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
                        "Reset new password",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _newPasswordController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter new password',
                            labelText: 'Enter new password'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Confirm password',
                            labelText: 'Confirm password'),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                          if (_newPasswordController.text == "") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter new password")));
                            return;
                          }
                          if (_newPasswordController.text !=
                              _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Password doesn't match")));
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
                            resetPassword(
                                _newPasswordController.text.toString());
                          } catch (e) {
                            String err = e.toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: $err')));
                          }
                        },
                        child: const Text(
                          "Reset Password",
                        ),
                      ),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text('Note'),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text(
                    //     'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt'
                    //     ' ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud'
                    //     ' exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
                    //     ' Duis aute irure dolor in reprehenderit in voluptate velit esse cillum '
                    //     'dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,'
                    //     ' sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    //     style: TextStyle(fontSize: 12),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> verifyOTP(String otp, String mobile) async {
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=otp_validation&auth_key=PCMCS56ADDGPIL'),
        body: {
          "mobile": mobile,
          "user_otp": otp,
        });
    if (response.statusCode == 200) {
      print('code: 200');

      var data = jsonDecode(response.body.toString());

      if (data['result_code'] == 0) {
        print('verify OTP success');
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('verify OTP success')));
        // stop progress bar
        Navigator.of(context).pop();
        // close current alert box
        Navigator.pop(context);

        // open reset password popup
        showResetPasswordAlert();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid OTP')));
        // stop progress bar
        Navigator.of(context).pop();
      }
    }
  }
}
