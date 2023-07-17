import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pcmc_staff/models/RecordModel.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late String? wardid;
  late String? message;
  late String? datetime;
  late String? ward_office;
  List<RecordModel> records = <RecordModel>[];
  Future<List<RecordModel>> getAlertsListDataFromAPI() async {
    // final prefs = await SharedPreferences.getInstance();
    // var customerID = prefs.getString('customerID');
    Response response = await get(
      Uri.parse(
          'https://pcmc.bioenabletech.com/api/service.php?q=notification_list&auth_key=PCMCS56ADDGPIL&wardid=2'),
    );
    final data = jsonDecode(response.body.toString());

    List jsonResponse = data['record'][0];

    print('data: $data');
    print(data['record'][0]);

    for (int i = 0; i <= jsonResponse.length; i++) {
      records.add(jsonResponse[i]);
      print('ith record: ${records[i]}');
    }

    return jsonResponse.map((e) => RecordModel.fromJson(e)).toList();
  }

  @override
  void initState() {
    wardid = '';
    message = '';
    datetime = '';
    ward_office = '';
    // getAlertsListDataFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: FutureBuilder(
        future: getAlertsListDataFromAPI(),
        builder: (context, data) {
          if (data.hasError) {
            print('ERROR: ${data.error}');

            return Text('${data.error}');
          } else if (data.hasData) {
            var items = data.data as List<RecordModel>;
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
                                Text('Alert/Issue ID: ${items[index].message}'),
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
