class ProfileDataModel {
  String? empid;
  String? staffname;
  String? email;
  String? mobile;
  String? employee_no;
  String? photo;
  String? date_of_birth;
  String? address;
  String? department;
  String? designation;
  String? ward_office;

  ProfileDataModel(
      {this.empid,
      this.staffname,
      this.email,
      this.mobile,
      this.employee_no,
      this.photo,
      this.date_of_birth,
      this.address,
      this.department,
      this.designation,
      this.ward_office});

  ProfileDataModel.fromJson(Map<String, dynamic> json) {
    empid = json['empid'];
    staffname = json['staffname'];
    email = json['email'];
    mobile = json['mobile'];
    employee_no = json['employee_no'];
    photo = json['photo'];
    date_of_birth = json['date_of_birth'];
    address = json['address'];
    department = json['department'];
    ward_office = json['ward_office'];
    designation = json['designation'];
  }

// Getter
  String? get getMobile => mobile;
}
