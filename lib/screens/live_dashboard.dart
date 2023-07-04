import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveDashBoard extends StatefulWidget {
  // final String _appTitle='Bin DashBoard';
  // final String _connectionString='https://pcmc.geodirect.in/gps/cctv/bin-status-map.php';
  //
  @override
  _LiveDashBoard createState() =>
      _LiveDashBoard();
}

class _LiveDashBoard extends State<LiveDashBoard> {
  final String _appTitle='Bin DashBoard';
  final String _connectionString='https://pcmc.geodirect.in/gps/maps/tracking-vehicle1.php';

  int _stackToView = 1;
  final _key = GlobalKey();
  _LiveDashBoard();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Live Dashboard',style: TextStyle(fontSize: 30),)),
      child: Container(
        child: SafeArea(
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
          top: true,
        ),
      ),
    );
  }
}