import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pcmc_staff/models/UserAttendence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homedash extends StatefulWidget {
  const Homedash({super.key});

  @override
  State<Homedash> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<Homedash> {
  late String? totalPresent;
  late String? totalAbsent;
  late String? taskCompleted;
  late String? taskPending;
  late var now = DateTime.now();
  late String formattedDate = DateFormat('yyyy-MM-dd').format(now);

  Future<List<UserAttendence>> getTeamMonthlygetData() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    // userDesignation = prefs.getString('designation');
    //print(staffID);
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    print(formattedDate);
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=attendanceLogs&auth_key=PCMCS56ADDGPIL&staff_id=8908&from_date=2023-01-01&to_date=$formattedDate'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    print('month data: $data');
    return data.map((e) => UserAttendence.fromJson(e)).toList();
  }

  // getMonthlyPresentData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var staffID = prefs.getString('staffID');
  //   //TODO: Pass staffID
  //   // userDesignation = prefs.getString('designation');
  //   // print(staffID);
  //   // final prefs = await SharedPreferences.getInstance();
  //   // var customerID = prefs.getString('customerID');
  //
  //   Response response = await get(
  //     Uri.parse(
  //         'https://pcmc.bioenabletech.com/api/service.php?q=monthly_present_details_by_super&auth_key=PCMCS56ADDGPIL&staff_id=1'),
  //   );
  //   final data = jsonDecode(response.body.toString());
  //   print(data['month']);
  //   setState(() {
  //     totalPresent = data['present'];
  //     totalAbsent = data['emp_absent'];
  //     taskCompleted = data['completed_task'];
  //     taskPending = data['pending_task'];
  //   });
  //
  //   // return data.map((e) => MonthlyDetailsModel.fromJson(e));
  // }

  @override
  void initState() {
    totalAbsent = '';
    totalPresent = '';
    taskCompleted = '';
    taskPending = '';
    //  getMonthlyPresentData();

    getAttendenceCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Attendance Dashboard"),
      // ),
      body: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8.0,
                    child: Ink(
                      width: 150,
                      height: 100,
                      // color: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        gradient: const LinearGradient(
                            colors: [Colors.greenAccent, Colors.teal],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('$totalPresent',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              const Text('Present Count',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.00,
                  ),
                  Card(
                    elevation: 8.0,
                    child: Ink(
                      width: 150,
                      height: 100,
                      // color: Colors.blue,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Colors.redAccent, Colors.deepOrangeAccent],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('$totalAbsent',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              const Text('Absent Count',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Team Time Card',
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          FutureBuilder(
            future: getTeamMonthlygetData(),
            builder: (context, data) {
              if (data.hasError) {
                return Text('${data.error}');
              } else if (data.hasData) {
                var items = data.data as List<UserAttendence>;
                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return DataTable(
                          // datatable widget
                          columns: [
                            // column to set the name
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(
                              label: Text(''),
                            ),
                          ],

                          rows: [
                            // row to set the values
                            DataRow(cells: [
                              DataCell(Text(items[index].rdate.toString())),
                              DataCell(
                                  Text(items[index].Recordtime.toString())),
                              DataCell(
                                  Text(items[index].punch_type.toString())),
                            ]),
                          ],
                        );
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Column(
                        //       children: [
                        //         Text(items[index].name.toString()),
                        //       ],
                        //     ),
                        //     const SizedBox(
                        //       width: 20,
                        //     ),
                        //     Column(
                        //       children: [
                        //         Text(items[index].rdate.toString()),
                        //       ],
                        //     ),
                        //     const SizedBox(
                        //       width: 20,
                        //     ),
                        //     Column(
                        //       children: [
                        //         Text(items[index].in_punch.toString()),
                        //       ],
                        //     ),
                        //     const SizedBox(
                        //       width: 20,
                        //     ),
                        //     Column(
                        //       children: [
                        //         Text(items[index].out_punch.toString()),
                        //       ],
                        //     ),
                        //   ],
                        // );
                      }),
                );
                //   Center(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         // crossAxisAlignment: ,
                //         children: [
                //           Text(items[index].name.toString()),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text('2'),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text('3'),
                //         ],
                //       )
                //     ],
                //   ),
                // );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void getAttendenceCount() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    //TODO: Pass staffID
    // userDesignation = prefs.getString('designation');
    // print(staffID);
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=monthly_present_details&auth_key=PCMCS56ADDGPIL&staff_id=12345'),
    );
    final data = jsonDecode(response.body.toString());
    print(data['month']);
    setState(() {
      totalPresent = data['present'];
      totalAbsent = data['emp_absent'];
      taskCompleted = data['completed_task'];
      taskPending = data['pending_task'];
    });

    // return data.map((e) => MonthlyDetailsModel.fromJson(e));
  }
}
