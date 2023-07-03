class EmployeeList {
  String? empid;
  String? profilepic;
  String? workid;
  String? name;
  String? address;
  String? email;
  String? date_of_birth;
  String? mobile;
  String? department;
  String? designation;
  String? ward;
  String? supervisor;


  EmployeeList (
      {this.empid,
        this.profilepic,
        this.email,
        this.mobile,
        this.name,
        this.supervisor,
        this.date_of_birth,
        this.address,
        this.department,
        this.designation,
        this.workid,this.ward,});

  EmployeeList.fromJson(Map<String, dynamic> json) {
    empid = json['employeeid'];
    profilepic = json['profilepic'];
    email = json['email'];
    mobile = json['mobile'];
    name = json['name'];
    supervisor = json['Supervisor'];
    date_of_birth = json['DOB'];
    address = json['address'];
    department = json['department'];
    workid = json['WorkID'];
    designation = json['designations'];
    ward = json['Ward'];

  }

// Getter
  String? get getMobile => mobile;
}
