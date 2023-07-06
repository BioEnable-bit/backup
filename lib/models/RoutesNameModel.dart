class RoutesNameModel {
  String? routeid;
  String? route_name;
  String? source;
  String? destination;

  RoutesNameModel({
    this.routeid,
    this.route_name,
    this.source,
    this.destination,
  });

  RoutesNameModel.fromJson(Map<String, dynamic> json) {
    routeid = json['routeid'];
    route_name = json['route_name'];
    source = json['source'];
    destination = json['destination'];
  }

// Getter
//   String? get getMobile => mobile;
}
