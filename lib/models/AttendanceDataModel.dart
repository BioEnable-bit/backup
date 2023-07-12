class AttendanceDataModel {
  String? name;
  String? Recorddate;
  String? rdate;
  String? Recordtime;
  String? EquipmentID;
  String? latitude;
  String? longitude;
  String? punch_type;

  AttendanceDataModel(
      {this.name,
      this.Recorddate,
      this.rdate,
      this.Recordtime,
      this.EquipmentID,
      this.latitude,
      this.longitude,
      this.punch_type});

  AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    Recorddate = json['Recorddate'];
    rdate = json['rdate'];
    EquipmentID = json['EquipmentID'];

    latitude = json['latitude'];
    longitude = json['longitude'];
    punch_type = json['punch_type'];
  }

// Getter
//   String? get getMobile => mobile;
}
