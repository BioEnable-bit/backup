import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/EmployeeList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AttendanceDataModel.dart';

class AttendanceLogs extends StatefulWidget {
  const AttendanceLogs({super.key});

  @override
  State<AttendanceLogs> createState() => _AttendanceLogsState();
}

class _AttendanceLogsState extends State<AttendanceLogs> {
  List<AttendanceDataModel> attendanceList = <AttendanceDataModel>[];

  String? _selectedFromDate;
  String? _selectedToDate;
  DateTime? startdate;
  DateTime? Enddate;
  late var formattedDate;
  EmployeeList? selectedemployee;
  DateTime currentDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2050));
    print(currentDate);
    Enddate = pickedDate;
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
    print('""""""""""""""""""""""');
    print(Enddate);
    print('""""""""""""""""""""""');
  }

  List<EmployeeList> employee = <EmployeeList>[];
  Future getEmployeeNames() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    Response response = await get(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=emplist&auth_key=PCMCS56ADDGPIL&staff_id=$staffID'));
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);
      print(jsonDataZones.toString());
      // print(jsonDataZones[0]['designation']);
      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          employee.add(EmployeeList(
              name: jsonDataZones[i]['name'].toString(),
              empid: jsonDataZones[i]['employeeid'].toString()));
          // zoneNamesList.add(
          //     {jsonDataZones[i]['ward_id'], jsonDataZones[i]['ward_name']});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployeeNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Select Employee :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  DropdownButton<EmployeeList>(
                    hint: const Text("Employee List"),
                    value: selectedemployee,
                    onChanged: (EmployeeList? newValue) {
                      setState(() {
                        selectedemployee = newValue!;
                        print(selectedemployee.toString());

                        // getAlldesigNames();
                        // getAlldesigNames(selectedDesignation?.desig_id.toString());
                      });
                      // print(zones.indexOf(newValue!));
                    },
                    items: employee.map((EmployeeList employeeModel) {
                      return DropdownMenuItem<EmployeeList>(
                        value: employeeModel,
                        child: Text(
                          employeeModel.name.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.00,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DateTimePicker(
                  initialValue:
                      '', // initialValue or controller.text can be null, empty or a DateTime string otherwise it will throw an error.
                  type: DateTimePickerType.date,
                  dateLabelText: 'Select From Date',
                  firstDate: DateTime(1995),
                  lastDate: DateTime.now().add(const Duration(
                      days: 365)), // This will add one year from current date
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _selectedFromDate = value;
                        print(_selectedFromDate);
                      });
                    }
                  },
                  // We can also use onSaved
                  onSaved: (value) {
                    if (value!.isNotEmpty) {
                      _selectedFromDate = value;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10.00,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DateTimePicker(
                  initialValue:
                      '', // initialValue or controller.text can be null, empty or a DateTime string otherwise it will throw an error.
                  type: DateTimePickerType.date,
                  dateLabelText: 'Select To Date',
                  firstDate: DateTime(1995),
                  lastDate: DateTime.now().add(const Duration(
                      days: 365)), // This will add one year from current date
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _selectedToDate = value;
                        print(_selectedToDate);
                      });
                    }
                  },
                  // We can also use onSaved
                  onSaved: (value) {
                    if (value!.isNotEmpty) {
                      _selectedToDate = value;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30.00,
              ),
              ElevatedButton(
                  onPressed: () {
                    try {
                      //start progress bar
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      //call method
                      //Passing dummy image foe now TODO: change with image selected from camera/gallery
                      getEmployeeAttendanceData();
                      //stop progress bar
                      // stop progress bar
                      Navigator.of(context).pop();
                      print('attendanceList ${attendanceList.toString()}');
                      // attendanceList != []
                      //     ? Expanded(
                      //         child: ListView.builder(
                      //           itemCount: attendanceList.length,
                      //           itemBuilder: (BuildContext context, int index) {
                      //             return SingleChildScrollView(
                      //               scrollDirection: Axis.vertical,
                      //               child: DataTable(
                      //                   // Datatable widget that have the property columns and rows.
                      //                   columns: const [
                      //                     // Set the name of the column
                      //                     DataColumn(
                      //                       label: Text(''),
                      //                     ),
                      //                     DataColumn(
                      //                       label: Text(''),
                      //                     ),
                      //                     DataColumn(
                      //                       label: Text(''),
                      //                     ),
                      //                     // DataColumn(label: Text('Avg'),),
                      //                   ],
                      //                   rows: const [
                      //                     // Set the values to the columns
                      //                     DataRow(cells: [
                      //                       DataCell(Text("1 jan 2022")),
                      //                       DataCell(Text("8.29")),
                      //                       DataCell(Text("In")),
                      //                     ]),
                      //                     DataRow(cells: [
                      //                       DataCell(Text("2 jan 2022")),
                      //                       DataCell(Text("5.43")),
                      //                       DataCell(Text("out")),
                      //                     ]),
                      //                   ]),
                      //             );
                      //           },
                      //         ),
                      //       )
                      //     : const Text('No Data Found');
                    } catch (e) {
                      // stop progress bar
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(' Search ')),
              const SizedBox(
                height: 40.00,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: attendanceList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          // Datatable widget that have the property columns and rows.
                          columns: const [
                            // Set the name of the column
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(
                              label: Text(''),
                            ),
                            DataColumn(
                              label: Text(''),
                            ),
                            // DataColumn(label: Text('Avg'),),
                          ],
                          rows: attendanceList
                              .map((user) => DataRow(cells: [
                                    DataCell(Text('user.rdate.toString()')),
                                    DataCell(Text('user.Recordtime.toString()')),
                                    DataCell(Text('user.punch_type.toString()')),
                                  ]))
                              .toList(),
                          // const [
                          //   // Set the values to the columns
                          //   DataRow(cells: [
                          //     DataCell(Text("1 jan 2022")),
                          //     DataCell(Text("8.29")),
                          //     DataCell(Text("In")),
                          //   ]),
                          //   DataRow(cells: [
                          //     DataCell(Text("2 jan 2022")),
                          //     DataCell(Text("5.43")),
                          //     DataCell(Text("out")),
                          //   ]),
                          // ]),
                        ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<AttendanceDataModel>> getEmployeeAttendanceData() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    print(staffID);
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=attendanceLogs&auth_key=PCMCS56ADDGPIL&staff_id=8908&from_date=2023-01-01&to_date=2023-07-01'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    print("data $data");
    setState(() {
      for (int i = 0; i < data.length; i++) {
        // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
        attendanceList.add(AttendanceDataModel(
          rdate: data[i]['rdate'].toString(),
          Recordtime: data[i]['Recordtime'].toString(),
          punch_type: data[i]['punch_type'].toString(),
        ));
        // zoneNamesList.add(
        //     {jsonDataZones[i]['ward_id'], jsonDataZones[i]['ward_name']});
      }
    });
    return data.map((e) => AttendanceDataModel.fromJson(e)).toList();
  }
}
