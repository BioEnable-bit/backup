class TasksListModel {
  String? taskid;
  String? emp_id;
  String? task;
  String? description;
  String? status;
  String? assigned_to;
  String? assigned_date;
  String? due_date;

  TasksListModel(
      {this.taskid,
      this.emp_id,
      this.task,
      this.description,
      this.status,
      this.assigned_to,
      this.assigned_date,
      this.due_date});

  TasksListModel.fromJson(Map<String, dynamic> json) {
    taskid = json['taskid'];
    emp_id = json['emp_id'];
    task = json['task'];
    description = json['description'];
    status = json['status'];
    assigned_to = json['assigned_to'];
    assigned_date = json['assigned_date'];
    due_date = json['due_date'];
  }

// Getter
//   String? get getMobile => mobile;
}
