class RecordModel {
  String? wardid;
  String? message;
  String? datetime;
  String? ward_office;

  RecordModel(
      {required this.wardid,
      required this.message,
      required this.datetime,
      required this.ward_office});

  RecordModel.fromJson(Map<String, dynamic> json) {
    wardid = json['wardid'];
    message = json['message'];
    datetime = json['datetime'];
    ward_office = json['ward_office'];
  }
}
