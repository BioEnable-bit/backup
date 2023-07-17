class TeamMonthlyTimeCardModel {
  String? name;
  String? Recorddate;
  String? rdate;
  String? in_punch;
  String? out_punch;
  String? total_hrs;

  String? total_days;

  TeamMonthlyTimeCardModel(
      {this.name,
      this.Recorddate,
      this.rdate,
      this.in_punch,
      this.out_punch,
      this.total_hrs,
      this.total_days});

  TeamMonthlyTimeCardModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    Recorddate = json['Recorddate'];
    rdate = json['rdate'];
    in_punch = json['in_punch'];
    out_punch = json['out_punch'];
    total_hrs = json['total_hrs'];

    total_days = json['total_days'];
  }

// Getter
}
