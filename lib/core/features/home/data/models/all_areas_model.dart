class AllAreasModel {
  final String name;
  final String country;

  AllAreasModel({required this.name, required this.country});

  factory AllAreasModel.fromJson(Map<String, dynamic> json) {
    return AllAreasModel(name: json['strArea'], country: json['strCountry']);
  }

  Map<String, dynamic> toJson() {
    return {'strArea': name, 'strCountry': country};
  }
}
