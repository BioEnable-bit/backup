import 'package:flutter/material.dart';

import 'home.dart';

class Homedash extends StatefulWidget {
  const Homedash({super.key});

  @override
  State<Homedash> createState() => _Homedash();
}

class _Homedash extends State<Homedash> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:SingleChildScrollView(

        child: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 8.0,
                      child: Ink(
                        width: 150,
                        height: 70,
                        // color: Colors.blue,
                        decoration: BoxDecoration(
                          color: Color(0xff3AB09E),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            // Function to be called when container is tapped
                            // Navigator.pushNamed(
                            //     context, '/complaint_list',
                            //     arguments: _customerID);

                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                // Icon(
                                //   // Icons.add,
                                //   color: Colors.white,
                                // ),
                                Text('Present Count',
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
                        height: 70,
                        // color: Colors.blue,
                        decoration: BoxDecoration(
                          color: Color(0xffDD9999),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            // get customer idurn ComplaintListScreen();
                            // }));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                               //Icon(Icons.list, color: Colors.white),
                                Text('Absent Count',
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
                  height: 30,
                ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                            Text('My Attendence',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          ],
                    ),
                const SizedBox(
                  height: 30,
                ),




                SingleChildScrollView(
                  scrollDirection: Axis.vertical,

                  child:           DataTable(
                    // Datatable widget that have the property columns and rows.
                    //   columns: [
                    //                     //     // Set the name of the column
                    //                     //     DataColumn(label: Text(''),),
                    //                     //     DataColumn(label: Text(''),),
                    //                     //     DataColumn(label: Text(''),),
                    //                     //     // DataColumn(label: Text('Avg'),),
                    //                     //   ],

                      columns: const [
                        DataColumn(label: Text('Date',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('In',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('out',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Avg',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),],
//
                      rows:[
                        // Set the values to the columns
                        DataRow(cells: [
                          DataCell(Text("1 jan 2022")),
                          DataCell(Text("8.29")),
                          DataCell(Text("5.09")),
                          DataCell(Text("9")),

                        ]),
                        DataRow(cells: [
                          DataCell(Text("2 jan 2022")),
                          DataCell(Text("8.43")),
                          DataCell(Text("4.49")),
                          DataCell(Text("8.54")),

                        ]),


                      ]
                  ),

                ),








//                   Column(
//
//
//
//
//                     mainAxisAlignment: MainAxisAlignment.start,
//
//
//
//                     child: FittedBox(
//
//                       child: DataTable(
// columns: const [
//  DataColumn(label: Text('Date',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
//  DataColumn(label: Text('In',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
//  DataColumn(label: Text('out',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
//  DataColumn(label: Text('Avg',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
//
//
// ],
//                         rows: [
//
//
//
//
//
//
//
//                         ],
//
//
//
//                       ),
//
//
//
//
//                     ),
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//                   ),
            // code for bottom nav screen
                ],

              ),




    ),
    ),
    );
  }
}
