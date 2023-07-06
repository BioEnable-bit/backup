class VehicalCategoryModel {
  String? id;
  String? carrier_category;

  VehicalCategoryModel({
    this.id,
    this.carrier_category,
  });

  VehicalCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carrier_category = json['carrier_category'];
  }

// Getter
//   String? get getMobile => mobile;
}
