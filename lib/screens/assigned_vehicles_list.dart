import 'dart:convert';
import 'dart:typed_data';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pcmc_staff/models/VehicleModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AssignedVehiclesModel.dart';
import '../models/RoutesNameModel.dart';
import '../models/VehicalCategoryModel.dart';
import 'home.dart';

class AssignedVehiclesList extends StatefulWidget {
  const AssignedVehiclesList({super.key});

  @override
  State<AssignedVehiclesList> createState() => _AssignedVehiclesListState();
}

class _AssignedVehiclesListState extends State<AssignedVehiclesList> {
  var _screenStage;

  VehicalCategoryModel? selectedVehicleCategory;
  List<VehicalCategoryModel> categoryList = <VehicalCategoryModel>[];

  RoutesNameModel? selectedRoute;
  List<RoutesNameModel> routeList = <RoutesNameModel>[];

  VehicleModel? selectedVehicle;
  List<VehicleModel> vehicleList = <VehicleModel>[];

  Future getVehicleCategoryList() async {
    // final prefs = await SharedPreferences.getInstance();
    // var staffID = prefs.getString('staffID');
    Response response = await post(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=masters&auth_key=PCMCS56ADDGPIL&type=carrier_category'));
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);
      // print(jsonDataZones[0]['ward_id']);
      // print(jsonDataZones[0]['ward_name']);
      _screenStage = "loaded";
      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          categoryList.add(VehicalCategoryModel(
              id: jsonDataZones[i]['id'].toString(),
              carrier_category:
                  jsonDataZones[i]['carrier_category'].toString()));
        }
      });
    }
  }

  Future getRouteList() async {
    // final prefs = await SharedPreferences.getInstance();
    // var staffID = prefs.getString('staffID');
    Response response = await post(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=route_list&auth_key=PCMCS56ADDGPIL'));
    // final jsonData = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);

      // print(jsonDataZones[0]['ward_id']);
      // print(jsonDataZones[0]['ward_name']);
      _screenStage = "loaded";
      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          // ZoneModel(ward_id: jsonDataZones[i]['ward_id'].toString(), ward_name: jsonDataZones[i]['ward_name'].toString());
          routeList.add(RoutesNameModel(
              routeid: jsonDataZones[i]['routeid'].toString(),
              route_name: jsonDataZones[i]['route_name'].toString(),
              source: jsonDataZones[i]['source'].toString(),
              destination: jsonDataZones[i]['destination'].toString()));
        }
      });
    }
  }

  Future getVehiclesList() async {
    Response response = await post(Uri.parse(
        'https://pcmc.bioenabletech.com/api/service.php?q=assigned_route_det_list&auth_key=PCMCS56ADDGPIL'));

    if (response.statusCode == 200) {
      var jsonDataZones = json.decode(response.body);

      _screenStage = "loaded";

      setState(() {
        for (int i = 0; i < jsonDataZones.length; i++) {
          vehicleList.add(VehicleModel(
              id: jsonDataZones[i]['id'].toString(),
              vehicle_name: jsonDataZones[i]['vehicle_name'].toString(),
              carrier_category: jsonDataZones[i]['carrier_category'].toString(),
              route_name: jsonDataZones[i]['route_name'].toString()));
        }
      });
    }
  }

  String? _selectedDate;

  Uint8List? _image;
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  late String? userDesignation;

  Future<List<AssignedVehiclesModel>>
      getAssignedVehiclesListDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var staffID = prefs.getString('staffID');
    // userDesignation = prefs.getString('designation');

    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=assigned_route_det_list&auth_key=PCMCS56ADDGPIL'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    // print('data:  $data');

    return data.map((e) => AssignedVehiclesModel.fromJson(e)).toList();
  }

  Future<List<RoutesNameModel>> getRouteDataFromAPI() async {
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=route_list&auth_key=PCMCS56ADDGPIL'),
    );
    final data = jsonDecode(response.body.toString()) as List<dynamic>;
    // print('data:  $data');

    return data.map((e) => RoutesNameModel.fromJson(e)).toList();
  }

  void AssignVehicleAPICall(date, route_id, vehicle_type, carrier) async {
    final prefs = await SharedPreferences.getInstance();
    var staffID = prefs.getString('staffID');
    Response response = await post(
        Uri.parse(
            'https://pcmc.bioenabletech.com/api/service.php?q=add_route_carrier&auth_key=PCMCS56ADDGPIL'),
        body: {
          'created_by':
              staffID, // submitting the staffID of supervisor who have assigned the vehicle
          'date': date,
          'route_id': route_id,
          'vehicle_type': vehicle_type,
          'carrier': carrier,
        });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      // print("data['msg'] : ${data['msg']}");
      if (data['msg'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle Assigned successfully')));
        // stop progress bar
        Navigator.of(context).pop();

        // close current alert box
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
        // stop progress bar
        Navigator.of(context).pop();
        return;
      }
    }
  }

  @override
  void initState() {
    _screenStage = "loading";
    getVehicleCategoryList();
    getRouteList();
    getVehiclesList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const Home();
            // Navigator.pop(context);
          })),
        ),
        title: const Text("Assigned Vehicles List"),
        actions: [
          RawMaterialButton(
            onPressed: () {
              assignVehicleAlert();
            },
            elevation: 1.0,
            fillColor: const Color(0xFFF5F6F9),
            padding: const EdgeInsets.all(5.0),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: getAssignedVehiclesListDataFromAPI(),
        builder: (context, data) {
          if (data.hasError) {
            return Text('${data.error}');
          } else if (data.hasData) {
            var items = data.data as List<AssignedVehiclesModel>;
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
                              //TODO: ADD FOLLOW UP DAILOG BOX
                              // When user clicks on task from tasks list he can add follow up on that particular tasks
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Task ID: ${items[index].id}'),
                                // Text('Task: ${items[index].vehicle_name}'),
                                // Text(
                                //     'Task Assigned to: ${items[index].route_name}'),
                                // Text(
                                //     'Assign date: ${items[index].carrier_category}'),
                                Row(
                                  children: [
                                    //
                                    const Icon(
                                      // creating the first icon.
                                      Icons.numbers,
                                      // size: size.width * .06,
                                      size: 20,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(items[index].id.toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    //
                                    const Icon(
                                      // creating the first icon.
                                      Icons.fire_truck,
                                      // size: size.width * .06,
                                      size: 20,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(items[index].vehicle_name.toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    //
                                    const Icon(
                                      // creating the first icon.
                                      Icons.route,
                                      // size: size.width * .06,
                                      size: 20,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(items[index].route_name.toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    //
                                    const Icon(
                                      // creating the first icon.
                                      Icons.category,
                                      // size: size.width * .06,
                                      size: 20,
                                      color: Colors.blueGrey,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(items[index]
                                        .carrier_category
                                        .toString()),
                                  ],
                                ),
                                // Text('Due date: ${items[index].due_date}'),
                                // Text('Status: ${items[index].status}'),
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

  assignVehicleAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Text(
              "Assign Vehicle",
              style: TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              height: 400,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DateTimePicker(
                        initialValue:
                            '', // initialValue or controller.text can be null, empty or a DateTime string otherwise it will throw an error.
                        type: DateTimePickerType.date,
                        dateLabelText: 'Select Date',
                        firstDate: DateTime(1995),
                        lastDate: DateTime.now().add(const Duration(
                            days:
                                365)), // This will add one year from current date
                        validator: (value) {
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _selectedDate = value;
                              // print(_selectedDate);
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
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      //TODO: Solve Selected Dropdown Option not Showing in dropdown selected value
                      children: [
                        _screenStage == "loaded"
                            ? DropdownButton<VehicalCategoryModel>(
                                isExpanded: true,
                                hint: const Text("Select an vehicle category"),
                                value: selectedVehicleCategory,
                                onChanged: (VehicalCategoryModel? newValue) {
                                  setState(() {
                                    selectedVehicleCategory = newValue;
                                  });
                                  // print(zones.indexOf(newValue!));
                                },
                                items: categoryList
                                    .map((VehicalCategoryModel vehicleModel) {
                                  return DropdownMenuItem<VehicalCategoryModel>(
                                    value: vehicleModel,
                                    child: Text(
                                      vehicleModel.carrier_category.toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: [
                        _screenStage == "loaded"
                            ? DropdownButton<VehicleModel>(
                                isExpanded: true,
                                hint: const Text("Select an vehicle"),
                                value: selectedVehicle,
                                onChanged: (VehicleModel? newValue) {
                                  setState(() {
                                    selectedVehicle = newValue;
                                  });
                                },
                                items: vehicleList
                                    .map((VehicleModel vehicleModel) {
                                  return DropdownMenuItem<VehicleModel>(
                                    value: vehicleModel,
                                    child: Text(
                                      vehicleModel.vehicle_name.toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: [
                        _screenStage == "loaded"
                            ? DropdownButton<RoutesNameModel>(
                                isExpanded: true,
                                hint: const Text("Select an route"),
                                value: selectedRoute,
                                onChanged: (RoutesNameModel? newValue) {
                                  setState(() {
                                    selectedRoute = newValue;
                                  });
                                },
                                items:
                                    routeList.map((RoutesNameModel routeModel) {
                                  return DropdownMenuItem<RoutesNameModel>(
                                    value: routeModel,
                                    child: Text(
                                      routeModel.route_name.toString(),
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                              )
                            : const CircularProgressIndicator(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('select an date')));
                              return;
                            }
                            if (selectedVehicleCategory == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('select an date')));
                              return;
                            }
                            if (selectedVehicle == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('select an date')));
                              return;
                            }
                            if (selectedRoute == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('select an date')));
                              return;
                            }
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  });
                              print('date: ${_selectedDate.toString()}');
                              print(
                                  'selectedRoute: ${selectedRoute!.routeid.toString()}');
                              print(
                                  'selectedVehicle: ${selectedVehicle!.id.toString()}');
                              print(
                                  'selectedVehicleCategory: ${selectedVehicleCategory!.id.toString()}');

                              AssignVehicleAPICall(
                                  _selectedDate.toString(),
                                  selectedRoute!.routeid.toString(),
                                  selectedVehicle!.id.toString(),
                                  selectedVehicleCategory!.id.toString());
                              // stop progress bar
                              Navigator.of(context).pop();
                            } catch (e) {
                              String err = e.toString();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('error: $err')));
                              // stop progress bar
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text(
                            "Submit",
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
