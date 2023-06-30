import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/FollowUpListModel.dart';

class FollowUpList extends StatefulWidget {
  const FollowUpList({super.key});

  @override
  State<FollowUpList> createState() => _FollowUpListState();
}

// raise alert will be an alert dialog
class _FollowUpListState extends State<FollowUpList> {
  Future<List<FollowUpListModel>> getTasksListDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=followup_list&auth_key=PCMCS56ADDGPIL&staff_id=40861'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;

    return data.map((e) => FollowUpListModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up List"),
      ),
      body: FutureBuilder(
        future: getTasksListDataFromAPI(),
        builder: (context, data) {
          if (data.hasError) {
            return Text('${data.error}');
          } else if (data.hasData) {
            var items = data.data as List<FollowUpListModel>;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
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
                                Text('Task: ' + items[index].task.toString()),
                                Text('Description: ' +
                                    items[index].description.toString()),
                                Text('Followup: ' +
                                    items[index].followup.toString()),
                                Text('Task Status: ' +
                                    items[index].task_status.toString()),
                                Text('Followup Date: ' +
                                    items[index].followup_date.toString()),

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
