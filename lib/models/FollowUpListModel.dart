class FollowUpListModel {
  String? task;
  String? description;
  String? followup;
  String? snapshot;
  String? url;
  String? task_status;
  String? followup_date;

  FollowUpListModel(
      {this.task,
      this.description,
      this.followup,
      this.snapshot,
      this.url,
      this.task_status,
      this.followup_date});

  FollowUpListModel.fromJson(Map<String, dynamic> json) {
    task = json['task'];
    description = json['description'];
    followup = json['followup'];
    snapshot = json['snapshot'];
    url = json['url'];
    task_status = json['task_status'];
    followup_date = json['followup_date'];
  }

// Getter
//   String? get getMobile => mobile;
}
