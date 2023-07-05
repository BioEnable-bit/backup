import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/EmployeeList.dart';
import 'package:pcmc_staff/models/LocationModel.dart';
import 'package:pcmc_staff/screens/task_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class NewTask extends StatefulWidget {
  const NewTask({super.key});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  // late String? staffID;
  // Time Picker
  String? _selectedDate;

  EmployeeList? selectedEmployee;
  List<EmployeeList> employeeList = <EmployeeList>[];

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  LocationModel? selectedLocation;
  List<LocationModel> locationList = <LocationModel>[];

  Future getEmployeesList() async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    Response response = await post(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=emplist&auth_key=PCMCS56ADDGPIL&staff_id=$staffID'));
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);
      // print(jsonDataZones[0]['ward_id']);
      // print(jsonDataZones[0]['ward_name']);
      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          employeeList.add(EmployeeList(
              empid: jsonDataZones[i]['employeeid'].toString(),
              name: jsonDataZones[i]['name'].toString()));
        }
      });
    }
  }

  List<String> statusList = <String>['New', 'Open', 'Close'];
  String? selectedStatus = 'New';

  List<String> priorityList = <String>['High', 'Low', 'Normal'];
  String? selectedPriority = 'High';

  Future getLocationList() async {
    Response response = await post(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=locations&auth_key=PCMCS56ADDGPIL'));
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);
      // print(jsonDataZones[0]['ward_id']);
      // print(jsonDataZones[0]['ward_name']);
      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          locationList.add(LocationModel(
              id: jsonDataZones[i]['id'].toString(),
              location: jsonDataZones[i]['location'].toString()));
        }
      });
    }
  }

  @override
  void initState() {
    // staffID = '';
    print('_selectedDate: $_selectedDate');
    getEmployeesList();
    getLocationList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Wrap(
                children: [
                  const Text('Select an Employee: '),
                  const SizedBox(
                    width: 5,
                  ),
                  DropdownButton<EmployeeList>(
                    isExpanded: true,
                    hint: const Text("Select an Employee"),
                    value: selectedEmployee,
                    onChanged: (EmployeeList? newValue) {
                      setState(() {
                        selectedEmployee = newValue;
                      });
                      // print(zones.indexOf(newValue!));
                    },
                    items: employeeList.map((EmployeeList employeeModel) {
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
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _taskController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'task',
                      labelText: 'task'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description',
                      labelText: 'Description'),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: Wrap(
                  children: [
                    const Text('Select an Location: '),
                    const SizedBox(
                      width: 5,
                    ),
                    DropdownButton<LocationModel>(
                      isExpanded:
                          true, // Adding this solved Right Overflowed by 137 Pixels
                      hint: const Text("Select an Location"),
                      value: selectedLocation,
                      onChanged: (LocationModel? newValue) {
                        setState(() {
                          selectedLocation = newValue;
                        });
                        // print(zones.indexOf(newValue!));
                      },
                      items: locationList.map((LocationModel locationModel) {
                        return DropdownMenuItem<LocationModel>(
                          value: locationModel,
                          child: Text(
                            locationModel.location.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedPriority,
                  items: priorityList.map((String complaint) {
                    return DropdownMenuItem<String>(
                      value: complaint,
                      child: Text(complaint),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedPriority = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Priority',
                    hintText: 'Select from drop down',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: statusList.map((String complaint) {
                    return DropdownMenuItem<String>(
                      value: complaint,
                      child: Text(complaint),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Task Status',
                    hintText: 'Select from drop down',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: DateTimePicker(
                  initialValue:
                      '', // initialValue or controller.text can be null, empty or a DateTime string otherwise it will throw an error.
                  type: DateTimePickerType.date,
                  dateLabelText: 'Select Due Date',
                  firstDate: DateTime(1995),
                  lastDate: DateTime.now().add(const Duration(
                      days: 365)), // This will add one year from current date
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _selectedDate = value;
                        print(_selectedDate);
                      });
                    }
                  },
                  // We can also use onSaved
                  onSaved: (value) {
                    if (value!.isNotEmpty) {
                      _selectedDate = value;
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _descriptionController.clear();
                        _taskController.clear();
                      },
                      child: const Text('Reset')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // null check
                        if (selectedEmployee == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('please select employee')));
                          return;
                        }
                        if (_taskController.text.toString().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('please enter task')));
                          return;
                        }
                        if (_descriptionController.text.toString().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('please enter description')));
                          return;
                        }
                        if (selectedLocation == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('please select location')));
                          return;
                        }
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('please select an due date')));
                          return;
                        }
                        // if () {
                        //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //       content: Text('please enter description')));
                        //   return;
                        // }
                        // try catch
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
                          // print(staffID);
                          // print(selectedEmployee!.empid.toString());
                          // print(_taskController.text.toString());
                          // print(_descriptionController.text.toString());
                          // print(selectedLocation!.location.toString());
                          // print(selectedPriority.toString());
                          // print(selectedStatus.toString());
                          // print(_selectedDate.toString());
                          addTaskAPI(
                              selectedEmployee!.empid.toString(),
                              _taskController.text.toString(),
                              _descriptionController.text.toString(),
                              selectedLocation!.location.toString(),
                              selectedPriority.toString(),
                              selectedStatus.toString(),
                              _selectedDate.toString());
                          // stop progress bar
                          Navigator.of(context).pop();
                        } catch (e) {
                          // stop progress bar
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Save')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addTaskAPI(employeeID, task, description, location, priority,
      task_status, due_date) async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=add_task&auth_key=PCMCS56ADDGPIL'),
        body: {
          'emp_id':
              employeeID, // employee ID of selected employee from employee list dropdown
          'supervisor': staffID, //Supervisor is loggedInSupervisorID
          'task': task,
          'description': description,
          'location': location,
          'priority': priority,
          'task_status': task_status,
          'due_date': due_date,
        });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data[0]['msg'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task Added successfully')));
        // print('success');
        // stop progress bar
        Navigator.of(context).pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const TaskList();
          // Navigator.pop(context);
        }));
      } else {
        // String resp = data[0]['msg'];
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
        // print('Update failed');
        Navigator.of(context).pop();
        return;
      }
    }
  }
}
