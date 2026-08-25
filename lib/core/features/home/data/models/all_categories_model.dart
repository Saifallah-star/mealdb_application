class AllCategoriesModel {
  String? name;

  AllCategoriesModel({this.name});

  factory AllCategoriesModel.fromJson(Map<String, dynamic> json) {
    return AllCategoriesModel(name: json['strCategory']);
  }

  Map<String, dynamic> toJson() {
    return {'strCategory': name};
  }
}
