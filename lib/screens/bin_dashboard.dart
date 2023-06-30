import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home.dart';

class BinDashboard extends StatefulWidget {
  const BinDashboard({super.key});

  @override
  State<BinDashboard> createState() => _BinDashboardState();
}

class _BinDashboardState extends State<BinDashboard> {
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
        title: const Text("Bin Dashboard"),
      ),
      body: SizedBox(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const WebView(
            initialUrl: "https://pcmc.geodirect.in/gps/cctv/bin-status-map.php",
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
