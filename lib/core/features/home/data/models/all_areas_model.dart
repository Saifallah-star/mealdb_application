class AllAreasModel {
  final String name;
  final String country;

  AllAreasModel({required this.name, required this.country});

  factory AllAreasModel.fromJson(Map<String, dynamic> json) {
    return AllAreasModel(
      name: json['strArea'] as String? ?? 'Unknown area',
      country: json['strCountry'] as String? ?? 'Unknown country',
    );
  }

  Map<String, dynamic> toJson() {
    return {'strArea': name, 'strCountry': country};
  }
}
