class UserAttendence {
  String? name;
  String? Recorddate;
  String? rdate;
  String? Recordtime;
  String? EquipmentID;
  String? latitude;
  String? longitude;
  String? punch_type;

  UserAttendence({
    this.name,
    this.Recorddate,
    this.rdate,
    this.Recordtime,
    this.EquipmentID,
    this.latitude,
    this.longitude,
    this.punch_type,
  });

  UserAttendence.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    Recorddate = json['Recorddate'];
    rdate = json['rdate'];
    EquipmentID = json['EquipmentID'];
    Recordtime = json['Recordtime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    punch_type = json['punch_type'];
  }

// Getter
}
