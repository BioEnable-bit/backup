class AssignedVehiclesModel {
  String? id;
  String? vehicle_name;
  String? carrier_category;
  String? route_name;

  AssignedVehiclesModel({
    this.id,
    this.vehicle_name,
    this.carrier_category,
    this.route_name,
  });

  AssignedVehiclesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicle_name = json['vehicle_name'];
    carrier_category = json['carrier_category'];
    route_name = json['route_name'];
  }

// Getter
//   String? get getMobile => mobile;
}
