import 'package:flutter/material.dart';

class RouteMap extends StatefulWidget {
  const RouteMap({super.key});

  @override
  State<RouteMap> createState() => _RouteMapState();
}

class _RouteMapState extends State<RouteMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Map"),
      ),
    );
  }
}
