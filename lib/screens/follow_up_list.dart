import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/FollowUpListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class FollowUpList extends StatefulWidget {
  const FollowUpList({super.key});

  @override
  State<FollowUpList> createState() => _FollowUpListState();
}

// raise alert will be an alert dialog
class _FollowUpListState extends State<FollowUpList> {
  Future<List<FollowUpListModel>> getTasksListDataFromAPI() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    print(staffID);
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=followup_list&auth_key=PCMCS56ADDGPIL&staff_id=$staffID'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;

    return data.map((e) => FollowUpListModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
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
                    onTap: () {
                      // updateAlert();
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
                                Text('Task: ${items[index].task}'),
                                Text(
                                    'Description: ${items[index].description}'),
                                Text('Followup: ${items[index].followup}'),
                                Text(
                                    'Task Status: ${items[index].task_status}'),
                                Text(
                                    'Followup Date: ${items[index].followup_date}'),

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

  // updateAlert() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: const RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(
  //                 20.0,
  //               ),
  //             ),
  //           ),
  //           contentPadding: const EdgeInsets.only(
  //             top: 10.0,
  //           ),
  //           title: const Text(
  //             "Update Remark",
  //             style: TextStyle(fontSize: 24.0),
  //           ),
  //           content: SizedBox(
  //             height: 550,
  //             child: SingleChildScrollView(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   const Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: Text(
  //                       "Update Remark",
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: TextField(
  //                       controller: _remarkUpdateController,
  //                       decoration: const InputDecoration(
  //                           border: OutlineInputBorder(),
  //                           hintText: 'Update Remark',
  //                           labelText: 'Update Remark'),
  //                     ),
  //                   ),
  //                   Container(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: DropdownButtonFormField<String>(
  //                       value: selectedStatus,
  //                       items: statusList.map((String complaint) {
  //                         return DropdownMenuItem<String>(
  //                           value: complaint,
  //                           child: Text(complaint),
  //                         );
  //                       }).toList(),
  //                       onChanged: (String? value) {
  //                         setState(() {
  //                           selectedStatus = value;
  //                         });
  //                       },
  //                       decoration: const InputDecoration(
  //                         labelText: 'Status',
  //                         hintText: 'Select from drop down',
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     width: double.infinity,
  //                     height: 60,
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         try {
  //                           //start progress bar
  //                           showDialog(
  //                               context: context,
  //                               builder: (context) {
  //                                 return const Center(
  //                                   child: CircularProgressIndicator(),
  //                                 );
  //                               });
  //                           //call method
  //                           //Passing dummy image foe now TODO: change with image selected from camera/gallery
  //
  //                           //stop progress bar
  //                           // stop progress bar
  //                           Navigator.of(context).pop();
  //                         } catch (e) {
  //                           // stop progress bar
  //                           Navigator.of(context).pop();
  //                         }
  //                       },
  //                       child: const Text(
  //                         "Update",
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}
