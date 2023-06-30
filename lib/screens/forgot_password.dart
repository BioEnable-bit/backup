import 'package:flutter/material.dart';
import 'package:pcmc_staff/screens/sign_in.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
        title: const Text("Forgot Password"),
      ),
    );
  }
}
