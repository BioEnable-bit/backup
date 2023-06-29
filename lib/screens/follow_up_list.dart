import 'package:flutter/material.dart';

class FollowUpList extends StatefulWidget {
  const FollowUpList({super.key});

  @override
  State<FollowUpList> createState() => _FollowUpListState();
}

// raise alert will be an alert dialog
class _FollowUpListState extends State<FollowUpList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up List"),
      ),
    );
  }
}
