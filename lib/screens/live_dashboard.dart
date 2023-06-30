import 'package:flutter/material.dart';

import 'home.dart';

class LiveDashBoard extends StatefulWidget {
  const LiveDashBoard({super.key});

  @override
  State<LiveDashBoard> createState() => _LiveDashBoardState();
}

class _LiveDashBoardState extends State<LiveDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
        title: const Text("Monthly Time Card"),
      ),
    );
  }
}
