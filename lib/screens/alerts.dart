import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/AlertsListModel.dart';
import 'package:pcmc_staff/screens/home.dart';

class Alerts extends StatefulWidget {
  const Alerts({super.key});

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  Future<List<AlertsListModel>> getTasksListDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=issue_list&auth_key=PCMCS56ADDGPIL&staff_id=40861'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;

    return data.map((e) => AlertsListModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box, color: Colors.blueGrey),
            onPressed: () {
              // TODO: Add Alerts popup functionality
              print('clicked');
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getTasksListDataFromAPI(),
        builder: (context, data) {
          if (data.hasError) {
            return Text('${data.error}');
          } else if (data.hasData) {
            var items = data.data as List<AlertsListModel>;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      //TODO: ADD UPDATE REMARK FUNCTIONALITY ON TAP
                      // When user clicks on alert from alerts list he can add remark
                      //api: Update Issue Remark
                      // https://pcmc.bioenabletech.com/api/service.php?q=update_issue_remark&auth_key=PCMCS56ADDGPIL&id=140&staff_id=40861&remark_update=Bin Repaired&status=Closed
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10.0),
                      elevation: 5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Wrap(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Alert/Issue ID: ${items[index].issue_id}'),
                                Text(
                                    'Description: ${items[index].description}'),
                                Text('Raised By: ${items[index].raised_By}'),
                                Text('Employee ID: ${items[index].emp_id}'),
                                Text('Ward ID: ${items[index].ward_id}'),
                                Text('Remark: ${items[index].remark}'),
                                Text('Status: ${items[index].status}'),
                                Text('Created On: ${items[index].created_on}'),

                                // Text('Task: ' +
                                //     items[index].description.toString()),
                                // Text('Task Assigned to: ' +
                                //     items[index].assigned_to.toString()),
                                // Text('Assign date: ' +
                                //     items[index].assigned_date.toString()),
                                // Text('Due date: ' +
                                //     items[index].due_date.toString()),
                                // Text('Status: ' +
                                //     items[index].status.toString()),
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
}
