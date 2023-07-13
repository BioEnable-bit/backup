class TeamMonthlyTimeCardModel {
  String? name;
  String? Recorddate;
  String? rdate;
  String? in_punch;
  String? out_punch;
  String? total_hrs;

  TeamMonthlyTimeCardModel(
      {this.name,
      this.Recorddate,
      this.rdate,
      this.in_punch,
      this.out_punch,
      this.total_hrs});

  TeamMonthlyTimeCardModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    Recorddate = json['Recorddate'];
    rdate = json['rdate'];
    in_punch = json['in_punch'];
    out_punch = json['out_punch'];
    total_hrs = json['total_hrs'];
  }

// Getter
//   String? get getMobile => mobile;
}
