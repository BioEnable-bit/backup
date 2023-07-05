import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/TasksListModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // Create an instance variable.
  late final Future myFuture;
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  var _image;
  late String taskID;

  List<String> statusList = <String>['New', 'Open', 'Close'];
  String? selectedStatus = 'New';

  late String? userDesignation;

  Future<List<TasksListModel>> getTasksListDataFromAPI() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    userDesignation = prefs.getString('designation');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=task_list&auth_key=PCMCS56ADDGPIL&staff_id=$staffID'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    setState(() {
      taskID = data[0]['taskid'];
    });

    return data.map((e) => TasksListModel.fromJson(e)).toList();
  }

  void addFollowUpAPICall(remark, snapshot, url, task_status) async {
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=add_followup&auth_key=PCMCS56ADDGPIL'),
        body: {
          'task_id': taskID,
          'remark': remark,
          'snapshot': snapshot,
          'url': url,
          'task_status': task_status,
        });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      if (data[0]['msg'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Follow up added successfully')));
        // stop progress bar
        Navigator.of(context).pop();

        // close current alert box
        Navigator.pop(context);
      } else if (data == []) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Internal Server Error')));
        // stop progress bar
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Follow up failed')));
        // stop progress bar
        Navigator.of(context).pop();
        return;
      }
    }
  }

  @override
  void initState() {
    taskID = '';
    userDesignation = '';
    // Assign that variable your Future.
    myFuture = getTasksListDataFromAPI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
        title: const Text("Task List"),
        actions: [
          RawMaterialButton(
            onPressed: () {
              Navigator.pushNamed(context, '/new_task', arguments: {});
            },
            elevation: 1.0,
            fillColor: const Color(0xFFF5F6F9),
            padding: const EdgeInsets.all(5.0),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getTasksListDataFromAPI(),
        builder: (context, data) {
          if (data.hasError) {
            return Text('${data.error}');
          } else if (data.hasData) {
            var items = data.data as List<TasksListModel>;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      addFollowUpAlert();
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Wrap(
                          children: [
                            Column(
                              //TODO: ADD FOLLOW UP DAILOG BOX
                              // When user clicks on task from tasks list he can add follow up on that particular tasks
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Task ID: ${items[index].taskid}'),
                                Text('Task: ${items[index].description}'),
                                Text(
                                    'Task Assigned to: ${items[index].assigned_to}'),
                                Text(
                                    'Assign date: ${items[index].assigned_date}'),
                                Text('Due date: ${items[index].due_date}'),
                                Text('Status: ${items[index].status}'),
                                // Text('Name: ' +
                                //     items[index].cust_name.toString()),
                                // Text('Date and Time: ' +
                                //     items[index].datetime.toString()),
                                // Text('Complaint Status: ' +
                                //     items[index].status.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  addFollowUpAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Text(
              "Add Follow Up",
              style: TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              height: 550,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Add Follow up",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _remarkController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add Remark',
                            labelText: 'Add Remark'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Add Url',
                            labelText: 'Add Url'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<String>(
                        value: selectedStatus,
                        items: statusList.map((String complaint) {
                          return DropdownMenuItem<String>(
                            value: complaint,
                            child: Text(complaint),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedStatus = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          hintText: 'Select from drop down',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          _image == null
                              ? Image.asset(
                                  'assets/image_placeholder.png',
                                  height: 100,
                                  width: 150,
                                )
                              : Image.file(
                                  _image!,
                                  height: 100,
                                  width: 150,
                                ),
                          // Image.asset('assets/pick_image.png',
                          //     height: 150, width: 200),
                          const SizedBox(width: 5),
                          InkWell(
                            child: const Icon(
                              Icons.camera_alt,
                              size: 30,
                            ),
                            onTap: () async {
                              var status = await Permission.camera.status;
                              if (!status.isGranted) {
                                await Permission.camera.request();
                              }
                              //TODO: SELECT IMAGE FROM CAMERA
                              // getImage();
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_remarkController.text.toString().isEmpty ||
                              _urlController.text.toString().isEmpty ||
                              selectedStatus.toString().isEmpty) {
                            return;
                          }
                          try {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                });
                            //TODO: ADD IMAGE FILE UPLOAD FEATURE
                            addFollowUpAPICall(
                              _remarkController.text.toString(),
                              '',
                              _urlController.text.toString(),
                              selectedStatus.toString(),
                            );
                          } catch (e) {
                            String err = e.toString();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('error: $err')));
                          }
                        },
                        child: const Text(
                          "Add Follow Up",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void getUserDesignation() async {
    final prefs = await SharedPreferences.getInstance();
    var designation = prefs.getString('designation');
    print('designation: $designation');
    setState(() {
      userDesignation = prefs.getString('designation');
    });
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class AppPage extends StatefulWidget {
//   final String _appTitle;
//   final String _connectionString;
//   AppPage(this._appTitle, this._connectionString);
//   @override
//   _AppPageState createState() =>
//       _AppPageState(this._appTitle, this._connectionString);
// }

// class _AppPageState extends State<AppPage> {
//   final String _appTitle;
//   final String _connectionString;
//   num _stackToView = 1;
//   final _key = GlobalKey();
//   _AppPageState(this._appTitle, this._connectionString);
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(middle: Text(_appTitle)),
//       child: Container(
//         child: SafeArea(
//           child: IndexedStack(
//             index: _stackToView,
//             children: <Widget>[
//               WebView(
//                 key: _key,
//                 javascriptMode: JavascriptMode.unrestricted,
//                 initialUrl: this._connectionString,
//                 onPageStarted: (value) => setState(() {
//                   _stackToView = 1;
//                 }),
//                 onPageFinished: (value) => setState(() {
//                   _stackToView = 0;
//                 }),
//               ),
//               Container(
//                 color: Color.fromRGBO(250, 250, 250, 1),
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             ],
//           ),
//           top: true,
//         ),
//       ),
//     );
//   }
// }
