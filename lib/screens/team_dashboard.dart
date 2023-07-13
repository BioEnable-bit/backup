import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/TeamMonthlyTimeCardModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamDashboard extends StatefulWidget {
  const TeamDashboard({super.key});

  @override
  State<TeamDashboard> createState() => _TeamDashboardState();
}

class _TeamDashboardState extends State<TeamDashboard> {
  late String? totalPresent;
  late String? totalAbsent;
  late String? taskCompleted;
  late String? taskPending;
  Future<List<TeamMonthlyTimeCardModel>> getTeamMonthlyData() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    // userDesignation = prefs.getString('designation');
    // print(staffID);
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=team_monthly_timecard&auth_key=PCMCS56ADDGPIL&staff_id=1&from_date=2022-12-01&to_date=2022-12-30'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    // print('month data: $data');
    return data.map((e) => TeamMonthlyTimeCardModel.fromJson(e)).toList();
  }

  getMonthlyPresentData() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    //TODO: Pass staffID
    // userDesignation = prefs.getString('designation');
    // print(staffID);
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=monthly_present_details_by_super&auth_key=PCMCS56ADDGPIL&staff_id=1'),
    );
    final data = jsonDecode(response.body.toString());
    // print(data['month']);
    setState(() {
      totalPresent = data['present'];
      totalAbsent = data['emp_absent'];
      taskCompleted = data['completed_task'];
      taskPending = data['pending_task'];
    });

    // return data.map((e) => MonthlyDetailsModel.fromJson(e));
  }

  @override
  void initState() {
    totalAbsent = '';
    totalPresent = '';
    taskCompleted = '';
    taskPending = '';
    getMonthlyPresentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team"),
      ),
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
                            colors: [Colors.blueGrey, Colors.lightBlue],
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
                              const Text('Total Present',
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
                            colors: [Colors.lightBlue, Colors.blueGrey],
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
                              const Text('Total Absent',
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
                            colors: [Colors.blueGrey, Colors.lightBlue],
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
                              Text('$taskCompleted',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              const Text('Task Completed',
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
                            colors: [Colors.lightBlue, Colors.blueGrey],
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
                              Text('$taskPending',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              const Text('Task Pending',
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
                    height: 20,
                  ),
                ],
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
            future: getTeamMonthlyData(),
            builder: (context, data) {
              if (data.hasError) {
                return Text('${data.error}');
              } else if (data.hasData) {
                var items = data.data as List<TeamMonthlyTimeCardModel>;
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
                            DataColumn(
                              label: Text(''),
                            ),
                          ],

                          rows: [
                            // row to set the values
                            DataRow(cells: [
                              DataCell(Text(items[index].name.toString())),
                              DataCell(Text(items[index].rdate.toString())),
                              DataCell(Text(items[index].in_punch.toString())),
                              DataCell(Text(items[index].out_punch.toString())),
                            ]),
                          ],
                        );
                      }),
                );
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
}
