import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/TasksListModel.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Future<List<TasksListModel>> getTasksListDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=task_list&auth_key=PCMCS56ADDGPIL&staff_id=40861'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;

    return data.map((e) => TasksListModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
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
                                Text('Task ID: ' +
                                    items[index].taskid.toString()),
                                Text('Task: ' +
                                    items[index].description.toString()),
                                Text('Task Assigned to: ' +
                                    items[index].assigned_to.toString()),
                                Text('Assign date: ' +
                                    items[index].assigned_date.toString()),
                                Text('Due date: ' +
                                    items[index].due_date.toString()),
                                Text('Status: ' +
                                    items[index].status.toString()),
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
