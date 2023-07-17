class MonthlyReport {
  String? name;
  String? month;
  String? emp_holiday;
  String? emp_absent;
  String? present;
  String? weekoff;
  String? total_days;
  String? pending_task;
  String? completed_task;

  MonthlyReport(
      {this.name,
      this.month,
      this.emp_holiday,
      this.emp_absent,
      this.present,
      this.weekoff,
      this.total_days,
      this.pending_task,
      this.completed_task});

  MonthlyReport.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    month = json['month'];
    emp_holiday = json['emp_holiday'];
    emp_absent = json['emp_absent'];
    present = json['present'];
    total_days = json['weekoff'];
    pending_task = json['pending_task'];
    completed_task = json['completed_task'];
  }

// Getter
}
