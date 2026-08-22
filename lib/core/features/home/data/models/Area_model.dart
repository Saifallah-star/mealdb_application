class AreaModel {
  final String name;
  final String country;

  AreaModel({required this.name, required this.country});

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(name: json['strArea'], country: json['strCountry']);
  }

  Map<String, dynamic> toJson() {
    return {'strArea': name, 'strCountry': country};
  }
}
