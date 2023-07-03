import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/EmployeeList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class MonthlyTimeCard extends StatefulWidget {
  const MonthlyTimeCard({super.key});

  @override
  State<MonthlyTimeCard> createState() => _MonthlyTimeCardState();
}

class _MonthlyTimeCardState extends State<MonthlyTimeCard> {
  get child => null;
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
    Enddate=pickedDate;
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
                  Text('Select Employee :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
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
                    items: employee.map(( EmployeeList employeeModel) {
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
              SizedBox(height:  10.00,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Text('Select from  :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),

                  ),


                ],




              ), SizedBox(height:  10.00,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Text('Select To :', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),

                  ),


                ],




              ),
              SizedBox(height:  30.00,),


              ElevatedButton(onPressed:(){}


                  , child: Text(' Search ')),
              SizedBox(height: 40.00,),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,

                child:           DataTable(
                  // Datatable widget that have the property columns and rows.
                    columns: [
                      // Set the name of the column
                      DataColumn(label: Text('Date'),),
                      DataColumn(label: Text('In'),),
                      DataColumn(label: Text('Out'),),
                      DataColumn(label: Text('Avg'),),
                    ],
                    rows:[
                      // Set the values to the columns
                      DataRow(cells: [
                        DataCell(Text("1 jan 2022")),
                        DataCell(Text("8.29")),
                        DataCell(Text("17.05")),
                        DataCell(Text("9.34")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("2 jan 2022")),
                        DataCell(Text("8.43")),
                        DataCell(Text("17.02")),
                        DataCell(Text("9.56")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("3 jan 2022")),
                        DataCell(Text("8.29")),
                        DataCell(Text("17.05")),
                        DataCell(Text("9.34")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("4 jan 2022")),
                        DataCell(Text("8.43")),
                        DataCell(Text("17.02")),
                        DataCell(Text("9.56")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("5 jan 2022")),
                        DataCell(Text("8.29")),
                        DataCell(Text("17.05")),
                        DataCell(Text("9.34")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("6 jan 2022")),
                        DataCell(Text("8.43")),
                        DataCell(Text("17.02")),
                        DataCell(Text("9.56")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("7 jan 2022")),
                        DataCell(Text("8.29")),
                        DataCell(Text("17.05")),
                        DataCell(Text("9.34")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("8 jan 2022")),
                        DataCell(Text("8.43")),
                        DataCell(Text("17.02")),
                        DataCell(Text("9.56")),
                      ]),  DataRow(cells: [
                        DataCell(Text("9 jan 2022")),
                        DataCell(Text("8.29")),
                        DataCell(Text("17.05")),
                        DataCell(Text("9.34")),
                      ]),
                      DataRow(cells: [
                        DataCell(Text("10 jan 2022")),
                        DataCell(Text("8.43")),
                        DataCell(Text("17.02")),
                        DataCell(Text("9.56")),
                      ]),

                    ]
                ),

              ),
            ],


          ),






        ),
      ),









    );
  }







}
