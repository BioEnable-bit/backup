import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

// afjisj
class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    print('Hello Yogesh');
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
    );
  }
}
