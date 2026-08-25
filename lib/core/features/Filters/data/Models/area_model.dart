class AreaModel {
  final String name;
  final String imageUrl;
  final String Area;
  final String Country;

  AreaModel({
    required this.name,
    required this.imageUrl,
    required this.Area,
    required this.Country,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      Area: json['strArea'] ?? '',
      Country: json['strCountry'] ?? '',
    );
  }
}
