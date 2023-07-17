import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/EmployeeList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AttendenceLogsModel.dart';

class AttendanceLogs extends StatefulWidget {
  const AttendanceLogs({super.key});

  @override
  State<AttendanceLogs> createState() => _AttendanceLogsState();
}

class _AttendanceLogsState extends State<AttendanceLogs> {
  List<AttendenceLogsModel> attendanceList = <AttendenceLogsModel>[];

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

    print(_selectedFromDate);

    Enddate = pickedDate;
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
      });
    print('""""""""""""""""""""""');
    print(_selectedToDate);
    print('""""""""""""""""""""""');
  }

  Future<List<AttendenceLogsModel>> getEmployeeAttendanceData() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    print(staffID);
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    print(_selectedFromDate);
    print(_selectedToDate);
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=attendanceLogs&auth_key=PCMCS56ADDGPIL&staff_id=$staffID&from_date=$_selectedFromDate&to_date=$_selectedToDate'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    if (data == []) {
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100.0),
        content: Text("Hello World!"),
      );
    }
    print("data $data");
    // setState(() {
    //   for (int i = 0; i < data.length; i++) {
    //     // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
    //     attendanceList.add(AttendenceLogsModel(
    //       rdate: data[i]['rdate'],
    //       Recordtime: data[i]['Recordtime'].toString(),
    //       punch_type: data[i]['punch_type'].toString(),
    //     ));
    //     // zoneNamesList.add(
    //     //     {jsonDataZones[i]['ward_id'], jsonDataZones[i]['ward_name']});
    //   }
    //
    // });
    return data.map((e) => AttendenceLogsModel.fromJson(e)).toList();
  }

  // Future<List<PeruserAttendence>> getTeamMonthlygetData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var staffID = prefs.getString('staffID');
  //   // userDesignation = prefs.getString('designation');
  //   //print(staffID);
  //   // final prefs = await SharedPreferences.getInstance();
  //   // var customerID = prefs.getString('customerID');
  //   print(formattedDate);
  //   Response response = await get(
  //     Uri.parse(
  //         'https://pcmc.bioenabletech.com/api/service.php?q=attendanceLogs&auth_key=PCMCS56ADDGPIL&staff_id=8908&from_date=2023-01-01&to_date=$formattedDate'),
  //   );
  //   final data = jsonDecode(response.body.toString()) as List<dynamic>;
  //   print('month data: $data');
  //   return data.map((e) => PeruserAttendence.fromJson(e)).toList();
  // }

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
    getEmployeeAttendanceData();
  }

  bool _isButtonClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      _selectedFromDate = value as String?;
                      print(_selectedFromDate);
                    });
                  }
                },
                // We can also use onSaved
                onSaved: (value) {
                  if (value!.isNotEmpty) {
                    _selectedFromDate = value as String?;
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
                      _selectedToDate = value as String?;
                      print(_selectedToDate);
                    });
                  }
                },
                // We can also use onSaved
                onSaved: (value) {
                  if (value!.isNotEmpty) {
                    _selectedToDate = value as String?;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 30.00,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isButtonClicked = true;
                  });
                },
                child: const Text('Search')),
            _isButtonClicked
                ? FutureBuilder(
                    future: getEmployeeAttendanceData(),
                    builder: (context, data) {
                      if (data.hasError) {
                        return Text('${data.error}');
                      } else if (data == []) {
                        return Text(" No Data Found");
                      } else if (data.hasData) {
                        var items = data.data as List<AttendenceLogsModel>;
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
                                      DataCell(
                                          Text(items[index].rdate.toString())),
                                      DataCell(Text(
                                          items[index].Recordtime.toString())),
                                      DataCell(Text(
                                          items[index].punch_type.toString())),
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
                  )
                : const Text('NO Data Found'),
            const SizedBox(
              height: 40.00,
            ),
          ],
        ),
      ),
    );
  }
}
