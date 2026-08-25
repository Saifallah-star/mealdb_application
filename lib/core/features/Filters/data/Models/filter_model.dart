class FilterModel {
  final String id;
  final String name;
  final String imageUrl;
  final String Area;
  final String Country;

  FilterModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.Area,
    required this.Country,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) {
    return FilterModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      imageUrl: json['strMealThumb'] ?? '',
      Area: json['strArea'] ?? '',
      Country: json['strCountry'] ?? '',
    );
  }
}
