import 'dart:convert';

List<AttendenceLogsModel> employeesFromJson(String str) =>
    List<AttendenceLogsModel>.from(
        json.decode(str).map((x) => AttendenceLogsModel.fromJson(x)));

String employeesToJson(List<AttendenceLogsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendenceLogsModel {
  String? name;
  String? Recorddate;
  String? rdate;
  String? Recordtime;
  String? EquipmentID;
  String? latitude;
  String? longitude;
  String? punch_type;

  AttendenceLogsModel({
    this.name,
    this.Recorddate,
    this.rdate,
    this.Recordtime,
    this.EquipmentID,
    this.latitude,
    this.longitude,
    this.punch_type,
  });

  AttendenceLogsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    Recorddate = json['Recorddate'];
    rdate = json['rdate'];
    EquipmentID = json['EquipmentID'];
    Recordtime = json['Recordtime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    punch_type = json['punch_type'];
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "Recorddate": Recorddate,
        "rdate": rdate,
        "EquipmentID": EquipmentID,
        "Recordtime": Recordtime,
        "latitude": latitude,
        "longitude": longitude,
        "punch_type": punch_type,
      };
// Getter
}
