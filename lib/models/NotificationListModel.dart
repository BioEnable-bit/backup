import 'RecordModel.dart';

class NotificationListModel {
  String? resultCode;
  List<RecordModel>? record;

  NotificationListModel({this.resultCode, this.record});
  NotificationListModel.fromJson(Map<String, dynamic> json) {
    resultCode = json['resultCode'];
    record = json['record'];
  }
}
