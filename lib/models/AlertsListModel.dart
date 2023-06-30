class AlertsListModel {
  String? issue_id;
  String? emp_id;
  String? raised_By;
  String? issue_type;
  String? image1;
  String? image2;
  String? description;
  String? ward_id;
  String? remark;
  String? latitude;
  String? longitude;
  String? status;
  String? created_on;

  AlertsListModel(
      {this.issue_id,
      this.emp_id,
      this.raised_By,
      this.issue_type,
      this.image1,
      this.image2,
      this.description,
      this.ward_id,
      this.remark,
      this.latitude,
      this.longitude,
      this.status,
      this.created_on});

  AlertsListModel.fromJson(Map<String, dynamic> json) {
    issue_id = json['issue_id'];
    emp_id = json['emp_id'];
    raised_By = json['raised_By'];
    issue_type = json['issue_type'];
    status = json['status'];
    image1 = json['image1'];
    image2 = json['image2'];
    description = json['description'];
    ward_id = json['ward_id'];
    remark = json['remark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    created_on = json['created_on'];
  }

// Getter
//   String? get getMobile => mobile;
}
