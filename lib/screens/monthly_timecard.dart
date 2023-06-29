import 'package:flutter/material.dart';

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
        title: const Text("Monthly Time Card"),
      ),
    );
  }
}
