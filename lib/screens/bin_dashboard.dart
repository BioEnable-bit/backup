import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BinDashboard extends StatefulWidget {
  // final String _appTitle='Bin DashBoard';
  // final String _connectionString='https://pcmc.geodirect.in/gps/cctv/bin-status-map.php';
  //
  @override
  _BinDashboardState createState() => _BinDashboardState();
}

class _BinDashboardState extends State<BinDashboard> {
  final String _appTitle = 'Bin DashBoard';
  final String _connectionString =
      'https://pcmc.geodirect.in/gps/cctv/bin-status-map.php';

  int _stackToView = 1;
  final _key = GlobalKey();
  _BinDashboardState();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
          middle: Text(
        'Bin Dashboard',
        style: TextStyle(fontSize: 30),
      )),
      child: SafeArea(
        top: true,
        child: IndexedStack(
          index: _stackToView,
          children: <Widget>[
            WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: this._connectionString,
              onPageStarted: (value) => setState(() {
                _stackToView = 1;
              }),
              onPageFinished: (value) => setState(() {
                _stackToView = 0;
              }),
            ),
            Container(
              color: Color.fromRGBO(250, 250, 250, 1),
              child: Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              ),
            )
          ],
        ),
      ),
    );
  }
}
