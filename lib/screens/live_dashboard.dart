import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        title: const Text("Live Dashboard"),
      ),
      body: SizedBox(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const WebView(
            initialUrl:
                "https://pcmc.geodirect.in/gps/maps/tracking-vehicle1.php",
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
