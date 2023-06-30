import 'package:flutter/material.dart';

import 'home.dart';

class MonthlyTimeCard extends StatefulWidget {
  const MonthlyTimeCard({super.key});

  @override
  State<MonthlyTimeCard> createState() => _MonthlyTimeCardState();
}

class _MonthlyTimeCardState extends State<MonthlyTimeCard> {
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
